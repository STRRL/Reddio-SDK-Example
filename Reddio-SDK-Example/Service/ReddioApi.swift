//
//  ReddioApi.swift
//  Reddio-SDK-Example
//
//  Created by STRRL on 2023/6/1.
//

import Foundation

// buy
let DIRECTION_BID = 1
// sell
let DIRECTION_ASK = 0

let REDDIO721_CONTRACT_ADDRESS = "0x941661bd1134dc7cc3d107bf006b8631f6e65ad5"

func orderInfo(
    starkKey: String,
    contract1: String,
    contract2: String
) async throws -> OrderInfoResponse {
    let url = URL(string: "https://api-dev.reddio.com/v1/order/info?stark_key=\(starkKey)&contract1=\(contract1)&contract2=\(contract2)")!
    let (data, _) = try await URLSession.shared.data(from: url)
    let responseBody = try JSONDecoder().decode(ResponseWrapper<OrderInfoResponse>.self, from: data)
    return responseBody.data
}

func buyNFTReddio721(
    starkPrivateKey: String,
    starkPublicKey: String,
    tokenId: String,
    price: String
) async throws -> OrderResponse {
    let jsonPayload = try await buildSignedBuyOrderMessage(
        starkPrivateKey: starkPrivateKey,
        starkPublicKey: starkPublicKey,
        baseTokenType: "ETH", baseTokenContract: "ETH",
        tokenType: "ERC721",
        // REDDIO721
        tokenContractAddress: REDDIO721_CONTRACT_ADDRESS,
        tokenId: tokenId,
        price: price, amount: "1"
    )

    var request = URLRequest(url: URL(string: "https://api-dev.reddio.com/v1/order")!, timeoutInterval: Double.infinity)
    request.httpMethod = "POST"
    request.httpBody = jsonPayload.data(using: .utf8)

    let (data, _) = try await URLSession.shared.data(for: request)
    let responseBody = try JSONDecoder().decode(ResponseWrapper<OrderResponse>.self, from: data)
    return responseBody.data
}

func buildSignedBuyOrderMessage(
    starkPrivateKey _: String,
    starkPublicKey: String,
    baseTokenType: String,
    baseTokenContract: String,
    tokenType: String,
    tokenContractAddress: String,
    tokenId _: String,
    price _: String,
    amount _: String
) async throws -> String {
    let orderInfoResponse = try await orderInfo(
        starkKey: starkPublicKey,
        contract1: "\(baseTokenType):\(baseTokenContract)",
        contract2: "\(tokenType):\(tokenContractAddress)"
    )
    let vaultIds = orderInfoResponse.vaultIds
    let quoteToken = orderInfoResponse.assetIds[1]
    return ""
}
