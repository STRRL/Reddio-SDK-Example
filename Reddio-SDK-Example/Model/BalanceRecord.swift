//
//  BalanceRecord.swift
//  Reddio-SDK-Example
//
//  Created by STRRL on 2023/6/7.
//

import Foundation

struct BalanceRecord: Codable {
    var contractAddress: String
    var type: String
    var decimals: Int64
    var quantum: Int64
    var displayValue: String
    var availableTokenIds: [String]?

    enum CodingKeys: String, CodingKey {
        case contractAddress = "contract_address"
        case type
        case decimals
        case quantum
        case displayValue = "display_value"
        case availableTokenIds = "available_token_ids"
    }
}
