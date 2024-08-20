//
//  LogService.swift
//  ZeneLuxe
//
//  Created by Omkar Zanjale on 12/02/24.
//

import Foundation

class LogService {
    
    let spacer = "\n \n"
    
    func printRESTRequestLogs(uid: String, method: RESTMethods, url: String, params: [String:String]?, headers: [String:String], body: Data?) {
        
        printLog(spacer)
        printLog("REQUEST------------------------------>>")
        
        printLog("UID: \(uid)")
        
        printLog("Method: \(method)")
        
        printLog("Path:\n    \(url)")
        printLog(spacer)
        
        if let params = params {
            printLog("Params:\n    \(params)")
            printLog(spacer)
        }
        
        if headers != [:] {
            printLog("Headers:\n    \(headers)")
            printLog(spacer)
        }
        
        if let body = body {
            let request = Tools.nsdataToJSON(data: body)
            if let request = request {
                printLog("Body:\n    \(request)")
                printLog(spacer)
            }
        }
        
    }
    
    func printRESTResponseLogs(uid: String, method: RESTMethods, url: String, response: Data?, error: Error?) {
        
        printLog(spacer)
        printLog("<<------------------------------RESPONSE")
        
        printLog("UID: \(uid)")
        
        printLog("Method: \(method)")
        
        printLog("Path:\n    \(url)")
        
        if let response = Tools.nsdataToJSON(data: response) {
            printLog("Response:\n\(response)")
            printLog(spacer)
        }
        
        if let error = error {
            printLog("Error:\n \(error)")
            printLog(spacer)
        }
        
    }
    
    func printError(error: Error?, string: String) {
        printLog("----------Error--------------")
        if let err = error {
            printLog("Description: \(err.localizedDescription)")
        }
        printLog("Description: \(string)")
        printLog("-----------------------------")
    }
    
}

