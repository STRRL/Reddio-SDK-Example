//
//  Web3Client.swift
//  Reddio-SDK-Example
//
//  Created by STRRL on 2023/6/5.
//

import Foundation
import GenericJSON
import ReddioKit
import web3

class Web3Client {
    static let RPC_URL = "https://rpc.ankr.com/eth_goerli"
    static let GENERATE_STARKKEY_MESSAGE = "Generate layer 2 key"

    private var ethAccount: EthereumAccount
    private var client: EthereumClientProtocol

    init(ethPrivateKey: String) throws {
        client = EthereumClient(url: URL(string: Web3Client.RPC_URL)!)
        ethAccount = try EthereumAccount(keyStorage: LiterallyEthKeyStorage(ethPrivateKey: ethPrivateKey))
    }

    func getAddress() -> EthereumAddress {
        return ethAccount.address
    }

    func fetchBalance() async throws -> Double {
        let balanceInWei = try await client.eth_getBalance(
            address: getAddress(),
            block: .Latest
        )
        let result = TorusWeb3Utils.toEther(wei: Wei(balanceInWei))
        return result
    }

    func getStarkPrivateKey() throws -> String {
        let typedData = TypedData(types: [
            "EIP712Domain": [TypedVariable(name: "chainId", type: "uint256")],
            "reddio": [TypedVariable(name: "contents", type: "string")],
        ],
        primaryType: "reddio",
        domain: ["chainId": 5],
        message: ["contents": try JSON(Web3Client.GENERATE_STARKKEY_MESSAGE)])
        let signature = try ethAccount.signMessage(message: typedData)
        let result = try "0x" + (ReddioKit.getPrivateKeyFromEthSignature(ethSignature: signature))
        return result
    }

    func getStarkPublicKey() throws -> String {
        let starkPrivateKey = try getStarkPrivateKey()
        return try "0x" + (ReddioKit.getPublicKey(privateKey: starkPrivateKey))
    }
}
