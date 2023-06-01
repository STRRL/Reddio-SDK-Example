//
//  ResponseWrapper.swift
//  Reddio-SDK-Example
//
//  Created by STRRL on 2023/6/1.
//

import Foundation

struct ResponseWrapper<T: Codable>: Codable {
    var status: String
    var error: String?
    var errorCode: Int64?
    var data: T?

    enum CodingKeys: String, CodingKey {
        case status
        case error
        case errorCode = "error_code"
        case data
    }
}
