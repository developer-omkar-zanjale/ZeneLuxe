//
//  Enums.swift
//  ZeneLuxe
//
//  Created by Omkar Zanjale on 12/02/24.
//



enum Environments {
    
    case DEV
    case QA
    case STAGE
    case PROD
    
}

enum ConnectionType: String {
    
    case secure = "https://"
    case insecure = "http://"
    
}

enum DataPopulation : String {
    
    case STATIC = "STATIC"
    case DYNAMIC = "DYNAMIC"
    
}

enum RESTMethods: String {
    
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
    case PATCH = "PATCH"
    
}

enum TrackState {
    case ready
    case isDownloading
    case isDownloadPaused
    case isDownloadResume
    case isPlaying
    case isPaused
}
