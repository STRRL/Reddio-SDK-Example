//
//  reddio.swift
//  Reddio-SDK-Example
//
//  Created by Yihan Li on 5/22/23.
//

import Foundation
import SwiftUI
import Combine

struct Asset: Identifiable {
    let id: String  // You might want to choose a more appropriate property for the id.
    let displayValue: String
    let symbol: String
    
    // Additional properties as needed.
}

class ReddioViewModel: ObservableObject {
//    @Published var filteredList: [[String: Any]] = []
    @Published var assets: [Asset] = []

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

    
    func mintNFT() {
        let parameters = "{\n    \"contract_address\":\"0x113536494406bc039586c1ad9b8f51af664d6ef8\",\n    \"stark_key\":\"0x123\",\n    \"amount\":\"10\"\n}"
        let postData = parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "https://api-dev.reddio.com/v1/mints")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("YOUR_API_KEY_HERE", forHTTPHeaderField: "X-API-Key")

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
