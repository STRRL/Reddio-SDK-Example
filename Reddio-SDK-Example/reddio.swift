//
//  reddio.swift
//  Reddio-SDK-Example
//
//  Created by Yihan Li on 5/22/23.
//

import Foundation
import SwiftUI
import Combine
import Reddio
import Web3Auth

struct Asset: Identifiable {
    let id: String  // You might want to choose a more appropriate property for the id.
    let displayValue: String
    let symbol: String
    
    // Additional properties as needed.
}

class ReddioViewModel: ObservableObject {
    @Published var assets: [Asset] = []
    @Published var starkey: String = ""
    @Published var publickey: String = ""
    
    func generatestarkey(signature : String) {
        let ethSignature = signature
        let result =  UnsafeMutablePointer<CChar>.allocate(capacity: 65)
        Reddio.get_private_key_from_eth_signature((ethSignature as NSString).utf8String, result)
        print(String(cString: result))
    }

    func getBalance() {
        guard let url = URL(string: "https://api-dev.reddio.com/v2/balances?stark_key=0x2209c1318b7021f4938546de573815bd0c5c9de2454e6d1f66766fc345dec80") else {
            print("Invalid URL")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
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
                              let baseUri = item["base_uri"] as? String else {
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
                                  let displayValue = item["display_value"] as? String else {
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

    
    func orderNFT() {
        let parameters = "{\n    \"amount\": \"1\",\n    \"price\": \"2000000000\",\n    \"stark_key\": \"0x626ce7cb6cd40cbdd5edd28f9714753c9de30f9e1379216e98cec04e064db96\",\n    \"amount_buy\": \"2000000000\",\n    \"amount_sell\": \"1\",\n    \"token_buy\": \"0x352f9ffd821a525051de2d71126113505a7b0a73d98dbc0ac0ff343cfbdef5e\",\n    \"token_sell\": \"0x4009ca493af0ee021faed912755cbb688130e0b17495b2453ab550a09774cea\",\n    \"vault_id_buy\": \"23403615\",\n    \"vault_id_sell\": \"23402806\",\n    \"expiration_timestamp\": 4194303,\n    \"base_token\": \"0x352f9ffd821a525051de2d71126113505a7b0a73d98dbc0ac0ff343cfbdef5e\",\n    \"quote_token\": \"0x4009ca493af0ee021faed912755cbb688130e0b17495b2453ab550a09774cea\",\n    \"nonce\": 83,\n    \"signature\": {\n        \"r\": \"0x6cd1f1055c3a3bd907fa5d9932e5ef3c76099f0899cd670be1e87c23ff5bb63\",\n        \"s\": \"0x551c077e228723d9ae87ab1d89ee4d63c4e31faa094867b6ba74aed1daa04c0\"\n    },\n    \"fee_info\": {\n        \"fee_limit\": 40000000,\n        \"token_id\": \"0x352f9ffd821a525051de2d71126113505a7b0a73d98dbc0ac0ff343cfbdef5e\",\n        \"source_vault_id\": 23403615\n    },\n    \"direction\": 0,\n    \"marketplace_uuid\": \"\"\n}"
        let postData = parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "https://api-dev.reddio.com/v1/order")!,timeoutInterval: Double.infinity)
        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
          print(String(data: data, encoding: .utf8)!)
        }

        task.resume()
    }
}
