//
//  ReddioApi.swift
//  Reddio-SDK-Example
//
//  Created by STRRL on 2023/6/1.
//

import Foundation
import ReddioKit
// buy
let DIRECTION_BID = 1
// sell
let DIRECTION_ASK = 0

let REDDIO721_CONTRACT_ADDRESS = "0x941661bd1134dc7cc3d107bf006b8631f6e65ad5"

func getOrderInfo(
    starkKey: String,
    contract1: String,
    contract2: String
) async throws -> OrderInfoResponse {
    let url = URL(string: "https://api-dev.reddio.com/v1/order/info?stark_key=\(starkKey)&contract1=\(contract1)&contract2=\(contract2)")!
    let (data, _) = try await URLSession.shared.data(from: url)
    let responseBody = try JSONDecoder().decode(ResponseWrapper<OrderInfoResponse>.self, from: data)
    return responseBody.data!
}

func getContractInfo(
    type: String,
    contractAddress: String
) async throws -> ContractInfo {
    let url = URL(string: "https://api-dev.reddio.com/v1/contract_info?type=\(type)&contract_address=\(contractAddress)")!
    let (data, _) = try await URLSession.shared.data(from: url)
    let responseBody = try JSONDecoder().decode(ResponseWrapper<ContractInfo>.self, from: data)
    return responseBody.data!
}

func buyNFTReddio721(
    starkPrivateKey: String,
    starkPublicKey: String,
    contractAddress: String = REDDIO721_CONTRACT_ADDRESS,
    tokenId: String,
    price: String
) async throws -> OrderResponse {
    let jsonPayload = try await buildSignedBuyOrderMessage(
        starkPrivateKey: starkPrivateKey,
        starkPublicKey: starkPublicKey,
        baseTokenType: "ETH",
        baseTokenContract: "ETH",
        tokenType: "ERC721",
        tokenContractAddress: contractAddress,
        tokenId: tokenId,
        price: price,
        amount: "1"
    )
    let jsonString = try JSONEncoder().encode(jsonPayload)

    var request = URLRequest(url: URL(string: "https://api-dev.reddio.com/v1/order")!, timeoutInterval: Double.infinity)
    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type") // the request is JSON
    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept") // the expected response is also JSON
    request.httpMethod = "POST"
    request.httpBody = jsonString

    let (data, _) = try await URLSession.shared.data(for: request)
    let responseBody = try JSONDecoder().decode(ResponseWrapper<OrderResponse>.self, from: data)
    return responseBody.data!
}

func sellNFTReddio721(
    starkPrivateKey: String,
    starkPublicKey: String,
    contractAddress: String = REDDIO721_CONTRACT_ADDRESS,
    tokenId: String,

    price: String
) async throws -> OrderResponse {
    let jsonPayload = try await buildSignedSellOrderMessage(
        starkPrivateKey: starkPrivateKey,
        starkPublicKey: starkPublicKey,
        baseTokenType: "ETH",
        baseTokenContract: "ETH",
        tokenType: "ERC721",

        tokenContractAddress: contractAddress,
        tokenId: tokenId,
        price: price,
        amount: "1"
    )
    let jsonString = try JSONEncoder().encode(jsonPayload)

    var request = URLRequest(url: URL(string: "https://api-dev.reddio.com/v1/order")!, timeoutInterval: Double.infinity)
    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type") // the request is JSON
    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept") // the expected response is also JSON
    request.httpMethod = "POST"
    request.httpBody = jsonString

    let (data, _) = try await URLSession.shared.data(for: request)
    let responseBody = try JSONDecoder().decode(ResponseWrapper<OrderResponse>.self, from: data)
    return responseBody.data!
}

func buildSignedSellOrderMessage(
    starkPrivateKey: String,
    starkPublicKey: String,
    baseTokenType: String,
    baseTokenContract: String,
    tokenType: String,
    tokenContractAddress: String,
    tokenId: String,
    price: String,
    amount: String
) async throws -> OrderMessage {
    let orderInfoResponse = try await getOrderInfo(
        starkKey: starkPublicKey,
        contract1: "\(baseTokenType):\(baseTokenContract)",
        contract2: "\(tokenType):\(tokenContractAddress):\(tokenId)"
    )
    let vaultIds = orderInfoResponse.vaultIds
    let quoteToken = orderInfoResponse.assetIds[1]

    let quantizedPrice = try await quantizedAmount(amount: price, type: baseTokenType, contractAddress: baseTokenContract)
    let amountBuy = Int64(Double(quantizedPrice)! * Double(amount)!).description
    let formatPrice = quantizedPrice

    var message = OrderMessage(
        amount: amount,
        amountBuy: amountBuy,
        amountSell: amount,
        tokenBuy: orderInfoResponse.baseToken,
        tokenSell: quoteToken,
        baseToken: orderInfoResponse.baseToken,
        quoteToken: quoteToken,
        vaultIdBuy: vaultIds[0],
        vaultIdSell: vaultIds[1],
        expirationTimestamp: 4_194_303,
        nonce: orderInfoResponse.nonce,
        signature: Signature(r: "", s: ""),
        direction: DIRECTION_ASK,
        feeInfo: FeeInfo(
            feeLimit: Int64(Double(orderInfoResponse.feeRate)! * Double(amountBuy)!),
            tokenId: orderInfoResponse.feeToken,
            sourceVaultId: Int64(vaultIds[0])!
        ),
        price: formatPrice,
        starkKey: starkPublicKey
    )

    let hash = try ReddioKit.getLimitOrderMsgHashWithFee(
        vaultSell: Int64(message.vaultIdSell)!,
        vaultBuy: Int64(message.vaultIdBuy)!,
        amountSell: Int64(message.amountSell)!,
        amountBuy: Int64(message.amountBuy)!,
        tokenSell: message.tokenSell,
        tokenBuy: message.tokenBuy,
        nonce: message.nonce,
        expirationTimestamp: message.expirationTimestamp,
        feeToken: message.feeInfo.tokenId,
        feeVaultId: message.feeInfo.sourceVaultId,
        feeLimit: message.feeInfo.feeLimit
    )
    let sign = try ReddioKit.sign(privateKey: starkPrivateKey, msgHash: hash, seed: nil)
    message.signature.r = sign.r
    message.signature.s = sign.s
    return message
}

func buildSignedBuyOrderMessage(
    starkPrivateKey: String,
    starkPublicKey: String,
    baseTokenType: String,
    baseTokenContract: String,
    tokenType: String,
    tokenContractAddress: String,
    tokenId: String,
    price: String,
    amount: String
) async throws -> OrderMessage {
    let orderInfoResponse = try await getOrderInfo(
        starkKey: starkPublicKey,
        contract1: "\(baseTokenType):\(baseTokenContract)",
        contract2: "\(tokenType):\(tokenContractAddress):\(tokenId)"
    )
    let vaultIds = orderInfoResponse.vaultIds
    let quoteToken = orderInfoResponse.assetIds[1]

    let quantizedPrice = try await quantizedAmount(amount: price, type: baseTokenType, contractAddress: baseTokenContract)
    let amountBuy = Int64(Double(quantizedPrice)! * Double(amount)!).description
    let formatPrice = quantizedPrice

    var message = OrderMessage(
        amount: amount,
        amountBuy: amount,
        amountSell: amountBuy,
        tokenBuy: quoteToken,
        tokenSell: orderInfoResponse.baseToken,
        baseToken: orderInfoResponse.baseToken,
        quoteToken: quoteToken,
        vaultIdBuy: vaultIds[1],
        vaultIdSell: vaultIds[0],
        expirationTimestamp: 4_194_303,
        nonce: orderInfoResponse.nonce,
        signature: Signature(r: "", s: ""),
        direction: DIRECTION_BID,
        feeInfo: FeeInfo(
            feeLimit: Int64(Double(orderInfoResponse.feeRate)! * Double(amountBuy)!),
            tokenId: orderInfoResponse.feeToken,
            sourceVaultId: Int64(vaultIds[0])!
        ),
        price: formatPrice,
        starkKey: starkPublicKey
    )

    let hash = try ReddioKit.getLimitOrderMsgHashWithFee(
        vaultSell: Int64(message.vaultIdSell)!,
        vaultBuy: Int64(message.vaultIdBuy)!,
        amountSell: Int64(message.amountSell)!,
        amountBuy: Int64(message.amountBuy)!,
        tokenSell: message.tokenSell,
        tokenBuy: message.tokenBuy,
        nonce: message.nonce,
        expirationTimestamp: message.expirationTimestamp,
        feeToken: message.feeInfo.tokenId,
        feeVaultId: message.feeInfo.sourceVaultId,
        feeLimit: message.feeInfo.feeLimit
    )
    let sign = try ReddioKit.sign(privateKey: starkPrivateKey, msgHash: hash, seed: nil)
    message.signature.r = sign.r
    message.signature.s = sign.s
    return message
}

func quantizedAmount(
    amount: String,
    type: String,
    contractAddress: String
) async throws -> String {
    let contractInfo = try await getContractInfo(type: type, contractAddress: contractAddress)

    let amountDecimal = Decimal(string: amount)!
    let result = amountDecimal * Decimal(pow(Double(10), Double(contractInfo.decimals))) / Decimal(string: contractInfo.quantum)!

    return result.description
}

func fetchNFTMetaData(contractAddress: String, tokenId: String) async throws -> String {
    let (responsBody, _) = try await URLSession.shared.data(from: URL(string:
        "https://metadata.reddio.com/metadata?token_ids=\(tokenId)&contract_address=\(contractAddress)"
    )!)
    let json = try JSONSerialization.jsonObject(with: responsBody, options: []) as? [String: Any]
    let data = json!["data"] as? [Any]
    let imageUrl = (data![0] as? [String: Any])!["image"] as! String
    return imageUrl
}

func getBalance(starkKey: String) async throws -> [BalanceRecord] {
    let url = "https://api-dev.reddio.com/v2/balances?stark_key=\(starkKey)"
    let (data, _) = try await URLSession.shared.data(from: URL(string: url)!)
    let responseBody = try JSONDecoder().decode(ResponseWrapper<[BalanceRecord]>.self, from: data)
    return responseBody.data!
}

func listForSaleNFT(contractAddress: String) async throws -> [ForSaleNFT] {
    let url = "https://api-dev.reddio.com/v1/orders?contract_address=\(contractAddress)"

    let (data, _) = try await URLSession.shared.data(from: URL(string: url)!)

    let responseBody = try JSONDecoder().decode(ResponseWrapper<ForSaleNFTOrderResponse>.self, from: data)
    return responseBody.data!.list
}
