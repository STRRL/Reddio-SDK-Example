//
//  OrderInfoResponse.swift
//  Reddio-SDK-Example
//
//  Created by STRRL on 2023/6/1.
//

import Foundation

struct Contract: Hashable, Codable {
    var contractAddress: String
    var symbol: String
    var decimals: Int64
    var type: String
    var quantum: Int64
    var assetType: String
    enum CodingKeys: String, CodingKey {
        case contractAddress = "contract_address"
        case symbol
        case decimals
        case type
        case quantum
        case assetType = "asset_type"
    }
}

struct OrderInfoResponse: Hashable, Codable {
    var feeRate: String
    var baseToken: String
    var feeToken: String
    var lowerLimit: Int64
    var nonce: Int64
    var contracts: [Contract]
    var vaultIds: [String]
    var assetIds: [String]

    enum CodingKeys: String, CodingKey {
        case feeRate = "fee_rate"
        case baseToken = "base_token"
        case feeToken = "fee_token"
        case lowerLimit = "lower_limit"
        case nonce
        case contracts
        case vaultIds = "vault_ids"
        case assetIds = "asset_ids"
    }
}
