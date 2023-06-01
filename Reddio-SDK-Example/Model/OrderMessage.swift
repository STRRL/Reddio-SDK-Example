//
//  OrderMessage.swift
//  Reddio-SDK-Example
//
//  Created by STRRL on 2023/6/1.
//

import Foundation

struct Signature: Hashable, Codable {
    var r: String
    var s: String
}

struct FeeInfo: Hashable, Codable {
    var feeLimit: Int64
    var tokenId: String
    var sourceVaultId: Int64

    enum CodingKeys: String, CodingKey {
        case feeLimit = "fee_limit"
        case tokenId = "token_id"
        case sourceVaultId = "source_vault_id"
    }
}

struct OrderMessage: Hashable, Codable {
    var amount: String
    var amountBuy: String
    var amountSell: String
    var tokenBuy: String
    var tokenSell: String
    var baseToken: String
    var quoteToken: String
    var vaultIdBuy: String
    var vaultIdSell: String
    var expirationTimestamp: Int64
    var nonce: Int64
    var signature: Signature
    var accountId: String
    var direction: Int64
    var feeInfo: FeeInfo
    var price: String
    var starkKey: String
    var stopLimitTimeInForce: String

    enum CodingKeys: String, CodingKey {
        case amount
        case amountBuy = "amount_buy"
        case amountSell = "amount_sell"
        case tokenBuy = "token_buy"
        case tokenSell = "token_sell"
        case baseToken = "base_token"
        case quoteToken = "quote_token"
        case vaultIdBuy = "vault_id_buy"
        case vaultIdSell = "vault_id_sell"
        case expirationTimestamp = "expiration_timestamp"
        case nonce
        case signature
        case accountId = "account_id"
        case direction
        case feeInfo = "fee_info"
        case price
        case starkKey = "stark_key"
        case stopLimitTimeInForce = "stop_limit_time_in_force"
    }
}
