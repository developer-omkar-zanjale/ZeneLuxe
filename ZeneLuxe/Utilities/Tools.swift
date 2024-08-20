//
//  Tools.swift
//  ZeneLuxe
//
//  Created by Omkar Zanjale on 13/02/24.
//

import Foundation

class Tools {
    
    //MARK: Conversions
    static func nsdataToJSON(data: Data?) -> AnyObject? {
        
        guard let data = data else {
            return nil
        }
        
        do {
            return try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as AnyObject
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil
    }
    
    static func decodeResponse<T:Decodable>(data: Data, type: T.Type) -> T? {
        
        var response:T?
        do {
            response = try JSONDecoder().decode(T.self, from: data)
        } catch {
            printError(error: error, string: nil)
        }
        
        return response
        
    }
    
    static func encodeRequest<T:Encodable>(data: T) -> Data? {
        
        var request:Data?
        do {
            request = try JSONEncoder().encode(data)
        } catch {
            printError(error: error, string: nil)
        }
        
        return request
        
    }
    
    static func encodeArrayRequest< T :Encodable>(data: [T] ) -> Data? {
        
        var request:Data?
        do {
            request = try JSONEncoder().encode(data)
        } catch {
            printError(error: error, string: nil)
        }
        
        return request
        
    }
    
    static func printError(error: Error?, string: String?) {
        
        print("CAUGHT WITH AN ERROR:\n\n")
        if let error = error {
            print(error)
        }
        if let string = string {
            print(string)
        }
        
    }
    
    
    
    static func encode <T: Encodable>(_ requestObj: T) -> Data? {
        return try? JSONEncoder().encode(requestObj)
    }
    
    static func getModelFromData<T:Decodable>(data: Data?, type: T.Type) -> T? {
        
        if let data = data {
            do {
                let response = try JSONDecoder().decode(type.self, from: data)
                return response
            }
            
            catch {
                print("Could not convert data to model")
            }
        }
        return nil
        
    }
    
}
