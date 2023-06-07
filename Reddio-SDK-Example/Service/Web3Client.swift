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
    private var client: EthereumClient
    private var ethPrivateKey: String

    init(ethPrivateKey: String) throws {
        self.ethPrivateKey = ethPrivateKey
        client = EthereumClient(url: URL(string: Web3Client.RPC_URL)!)
        ethAccount = try EthereumAccount(keyStorage: LiterallyEthKeyStorage(ethPrivateKey: ethPrivateKey))
    }

    func getAddress() -> EthereumAddress {
        ethAccount.address
    }

    func getEthPrivateKey() -> String {
        ethPrivateKey
    }

    func fetchBalance() async throws -> Double {
        let balanceInWei = try await client.eth_getBalance(
            address: getAddress(),
            block: .Latest
        )
        let result = TorusWeb3Utils.toEther(wei: Wei(balanceInWei))
        return result
    }

    func fecthERC20Balance(erc20ContractAddress: String) async throws -> Double {
        let erc20 = ERC20(client: client)
        let balance = try await erc20.balanceOf(tokenContract: EthereumAddress(erc20ContractAddress), address: getAddress())

        // resolve as same decimals with ETH
        let result = TorusWeb3Utils.toEther(wei: Wei(balance))
        return result
    }

    func fetchLayer2ETHBalance() async throws -> String {
        let balances = try await getBalance(starkKey: getStarkPublicKey())
        for (_, item) in balances.enumerated() {
            if item.type.lowercased() == "eth" {
                return item.displayValue
            }
        }

        return "N/A"
    }

    func fetchLayer2ERC20Balance() async throws -> String {
        let balances = try await getBalance(starkKey: getStarkPublicKey())
        for (_, item) in balances.enumerated() {
            if item.type.lowercased() == "erc20", item.contractAddress.lowercased() == "0x57f3560b6793dcc2cb274c39e8b8eba1dd18a086" {
                return item.displayValue
            }
        }

        return "N/A"
    }

    func fetchLayer2NFTs() async throws -> [NFT] {
        let balances = try await getBalance(starkKey: getStarkPublicKey())
        return balances.enumerated().filter { item in item.element.contractAddress.lowercased() == "0x941661bd1134dc7cc3d107bf006b8631f6e65ad5" }
            .flatMap { item in
                var result: [NFT] = []
                if item.element.availableTokenIds != nil {
                    for tokenId in item.element.availableTokenIds! {
                        result.append(NFT(contractAddress: item.element.contractAddress, tokenId: tokenId))
                    }
                }
                return result
            }
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

struct NFT {
    var contractAddress: String
    var tokenId: String
}
