//
//  reddio.swift
//  Reddio-SDK-Example
//
//  Created by Yihan Li on 5/22/23.
//

import Combine
import Foundation
import ReddioKit
import SwiftUI
import Web3Auth

struct Asset: Identifiable {
    let id: String // You might want to choose a more appropriate property for the id.
    let displayValue: String
    let symbol: String

    // Additional properties as needed.
}

class ReddioViewModel: ObservableObject {
    @Published var assets: [Asset] = []
    @Published var starkPublicKey: String = ""
    @Published var starkPrivateKey: String = ""

    func generatestarkey(signature: String) {
        do {
            starkPrivateKey = try "0x" + (ReddioKit.getPrivateKeyFromEthSignature(ethSignature: signature))
            starkPublicKey = try "0x" + (ReddioKit.getPublicKey(privateKey: starkPrivateKey))
        } catch {
            print("Failed to generate Stark Keys \(error)")
        }
    }

    func getBalance() {
        guard let url = URL(string: "https://api-dev.reddio.com/v2/balances?stark_key=\(starkPublicKey)") else {
            print("Invalid URL")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error: \(error)")
            } else if let data = data {
                do {
                    // Convert the data to JSON
                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                        print("Unable to parse response")
                        return
                    }

                    // Check for status
                    guard let status = json["status"] as? String, status != "FAILED" else {
                        print("Error status received")
                        return
                    }

                    // Get list of balances
                    guard let balanceList = json["data"] as? [[String: Any]] else {
                        print("Unable to retrieve balance list")
                        return
                    }

                    // Filter the list based on your criteria
                    let filteredList = balanceList.filter { item in
                        guard let type = item["type"] as? String,
                              let baseUri = item["base_uri"] as? String
                        else {
                            return false
                        }
                        return (type == "ETH" || type == "ERC20") || !baseUri.isEmpty
                    }

                    // Process the filtered list
                    // For example, print the filtered list
                    print(filteredList)
                    DispatchQueue.main.async {
                        self.assets = filteredList.map { item -> Asset? in
                            guard let symbol = item["symbol"] as? String,
                                  let displayValue = item["display_value"] as? String
                            else {
                                return nil
                            }
                            return Asset(id: symbol, displayValue: displayValue, symbol: symbol)
                        }.compactMap { $0 }
                    }
                } catch {
                    print("Failed to parse JSON: \(error)")
                }
            }
        }
        task.resume()
    }

    func buyREDDIO721NFT(tokenId: String, price: String) {
        Task {
            do {
                let orderResponse = try await buyNFTReddio721(starkPrivateKey: starkPrivateKey, starkPublicKey: starkPublicKey, tokenId: tokenId, price: price)
            } catch {
                print("\(error)")
            }
        }
    }
}
