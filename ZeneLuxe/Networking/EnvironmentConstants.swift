//
//  EnvironmentConstants.swift
//  ZeneLuxe
//
//  Created by Omkar Zanjale on 13/02/24.
//

import Foundation

enum EnvironmentConstants {
    
    static let currentEnvironment: Environments = {
        let vr: String = DatabaseService.getValue(forKey: UserDefaultConstants.envType, defaultValue: "STAGE")
        
        var env : Environments = .STAGE
        
        if vr == "DEV" {
            env = .DEV
        }
        
        if vr == "QA" {
            env = .QA
        }
        
        if vr == "STAGE" {
            env = .STAGE
        }
        
        return env
    }()
    
    static let networkProtocol : ConnectionType = .secure
    
    static let dataPopulation : DataPopulation = .DYNAMIC
    
    static let baseURL: String = {
        var returnURL = ""
        switch currentEnvironment {
        case .DEV:
            returnURL = ""
        case .QA:
            returnURL = ""
        case .STAGE:
            returnURL = "deezerdevs-deezer.p.rapidapi.com/"
        default:
            returnURL = ""
        }
        return networkProtocol.rawValue + returnURL
    }()
    
}
