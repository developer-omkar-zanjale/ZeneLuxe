//
//  NetworkManager.swift
//  ZeneLuxe
//
//  Created by Omkar Zanjale on 13/02/24.
//

import Foundation

class NetworkManager {
    
    let logger = LogService()
    
    func createRequest(method: RESTMethods, path: String, headers: [String:String]? , params: [String:String]?, body: Data?, completion: @escaping((Data?, ErrorResponseModel?)->())) {
        
        var apiHeaders = headers ?? [:]
        
        // Set URL
        var requestURL = EnvironmentConstants.baseURL + path
        
        // Set Parameters
        if let params = params {
            requestURL = requestURL + getParamsFromDictionary(params: params)
        }
        
        // Create Request
        let url = URL(string: requestURL)
        var request:URLRequest?
        if let url = url {
            request = URLRequest(url: url)
        } else {
            logger.printError(error: nil, string: "Invalid URL:\n \(requestURL)")
            return
        }
        guard var request = request else {
            logger.printError(error: nil, string: "Invalid request for: \(requestURL)")
            return
        }
        request.httpMethod = method.rawValue
        
        //Set Headers
        if let headers = headers {
            for item in headers {
                let key = item.key
                let value = item.value
                request.setValue(value, forHTTPHeaderField: key)
                
            }
        }
        
        if let value = UserDefaults.standard.value(forKey: UserDefaultConstants.accessToken) {
            if let token = value as? String {
                if token != "" {
                    request.setValue(token, forHTTPHeaderField: "Authorization")
                    apiHeaders["Authorization"] = "Bearer " + (value as? String ?? "")
                } else {
                    printLog("AUTH ERROR: Your Login session is no longer valid")
                }
            }
        }
        
        // Create Request Body
        if let body = body {
            request.httpBody = body
        }
        
        for item in apiHeaders {
            request.setValue(item.value, forHTTPHeaderField: item.key)
        }
        
        let requestUID = UUID().uuidString
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            self.logger.printRESTResponseLogs(uid: requestUID, method: method, url: requestURL, response: data, error: error)
            
            //Converting generic error to ErrorResponseModel
            if error != nil {
                let errorModel = ErrorResponseModel(error: "Unknown Network Error:\n\(error?.localizedDescription ?? "Unknown")", status: 1000)
                completion(nil,errorModel)
                return
            }
            
            var statusCode: Int = 401
            
            if let httpResponse = response as? HTTPURLResponse {
                printLog("statusCode: \(httpResponse.statusCode)")
                statusCode = httpResponse.statusCode
            }
            //Checking server error and returning ErrorResponseModel
            switch statusCode {
            case 401:
                //Unauthorized
                self.getRefreshToken { data, error in
                    if let data = data {
                        self.createRequest(method: method, path: path, headers: headers, params: params, body: data, completion: completion)
                        return
                    } else {
                        let errorModel = ErrorResponseModel(error: "Unauthorized!", status: 401)
                        completion(nil, errorModel)
                        return
                    }
                }
                
            case 200, 201:
                //Checking response data and returning data
                printLog("Success response")
                //Returning successful data
                completion(data, nil)
                
                
            case 400...499:
                //Client side errors
                //Cheking for data and decoding error
                if let data = data {
                    let resp = Tools.decodeResponse(data: data, type: ErrorResponseModel.self)
                    completion(nil, resp)
                } else {
                    let errorModel = ErrorResponseModel(error: "Invalid Request!", status: 400)
                    completion(nil,errorModel)
                }
                return
                
            case 500...599:
                //Server errors
                if let data = data {
                    let resp = Tools.decodeResponse(data: data, type: ErrorResponseModel.self)
                    completion(nil, resp)
                } else {
                    let errorModel = ErrorResponseModel(error: "Internal Server Error", status: 500)
                    completion(nil,errorModel)
                }
            default:
                let errorModel = ErrorResponseModel(error: "Unauthorized!", status: 401)
                completion(nil,errorModel)
                return
            }
        }
        
        logger.printRESTRequestLogs(uid: requestUID, method: method, url: requestURL, params: params, headers: apiHeaders, body: body)
        
        task.resume()
        
    }
    
    private func getParamsFromDictionary(params: [String:String]) -> String {
        
        var urlStr = ""
        if params.count > 0 {
            urlStr = urlStr + "?"
            for item in params {
                let key = item.key
                let value = item.value.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
                if key != "" && value != "" {
                    if urlStr.last != "?" {
                        urlStr = urlStr + "&"
                    }
                    urlStr = urlStr + "\(key)=\(value ?? "")"
                }
            }
        }
        return urlStr
        
    }
    
}
//
//MARK: Get new access token
//
extension NetworkManager {
    //Get new access token with refresh token
    func getRefreshToken(completion: @escaping((Data?, ErrorResponseModel?)->())) {
        let refreshToken: String = DatabaseService.getValue(forKey: UserDefaultConstants.refreshToken)
        if refreshToken.isEmpty {
            //returning if refresh token not found
            completion(nil, ErrorResponseModel(error: "Unauthorized!", status: 401))
            return
        }
        //Creating body data
        let dict = [
            "refresh_token": refreshToken,
            "client_secret": "-"
        ]
        let data = try? JSONSerialization.data(withJSONObject: dict, options: [])
        
        if let url = URL(string: "-") {
            
            var request = URLRequest(url: url)
            request.httpMethod = RESTMethods.POST.rawValue
            request.httpBody = data
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            //Creating API request
            let session = URLSession.shared
            let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
                printLog("Refresh token api called.")
                
                //Checking for error
                if let error = error {
                    Tools.printError(error: error, string: error.localizedDescription)
                    completion(nil, ErrorResponseModel(error: "Unauthorized!", status: 401))
                    return
                }
                
                //Checking for success data
                if let data = data {
                    //Decoding data response
                    if let responseDict = Tools.nsdataToJSON(data: data) as? [String: Any] {
                        let responseData = responseDict["data"] as? [String: Any]
                        let refreshToken = responseData?["refreshToken"] as? String ?? ""
                        let accessToken = responseData?["accessToken"] as? String ?? ""
                        //Checking for access token
                        if !refreshToken.isEmpty && !accessToken.isEmpty {
                            //Saving refresh & access token
                            DatabaseService.saveValue(accessToken, forKey: UserDefaultConstants.accessToken)
                            DatabaseService.saveValue(refreshToken, forKey: UserDefaultConstants.refreshToken)
                            //Success complition
                            completion(data, nil)
                        } else {
                            completion(nil, ErrorResponseModel(error: "Unauthorized!", status: 401))
                        }
                    } else {
                        completion(nil, ErrorResponseModel(error: "Unauthorized!", status: 401))
                    }
                } else {
                    completion(nil, ErrorResponseModel(error: "Unauthorized!", status: 401))
                }
            })
            task.resume()
        }
    }
}
