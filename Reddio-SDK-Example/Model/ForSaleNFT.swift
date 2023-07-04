//
//  ForSaleNFT.swift
//  Reddio-SDK-Example
//
//  Created by STRRL on 2023/7/4.
//

import Foundation

struct ForSaleNFT: Codable, Identifiable {
    var id: String {
        tokenType + symbol.quoteTokenContractAddr + tokenId
    }

    var starkKey: String
    var tokenType: String
    var displayPrice: String
    var tokenId: String
    var direction: UInt8
    var symbol: NFTSymbol

    enum CodingKeys: String, CodingKey {
        case starkKey = "stark_key"
        case tokenType = "token_type"
        case displayPrice = "display_price"
        case tokenId = "token_id"
        case direction
        case symbol
    }
}

struct NFTSymbol: Codable {
    var tokenType: String
    var tokenId: String
    var baseTokenName: String
    var quoteTokenContractAddr: String

    enum CodingKeys: String, CodingKey {
        case tokenType = "token_type"
        case tokenId = "token_id"
        case baseTokenName = "base_token_name"
        case quoteTokenContractAddr = "quote_token_contract_addr"
    }
}

struct ForSaleNFTOrderResponse: Codable {
    var list: [ForSaleNFT]
}
