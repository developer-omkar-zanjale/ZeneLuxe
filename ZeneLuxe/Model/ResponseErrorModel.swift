//
//  ResponseErrorModel.swift
//  ZeneLuxe
//
//  Created by Omkar Zanjale on 13/02/24.
//

import Foundation

struct ErrorResponseModel: Decodable {
    var error: String?
    var path: String?
    var requestId: String?
    var status: Int?
    var timestamp: String?
    var message: String?
    var code: String?
}
