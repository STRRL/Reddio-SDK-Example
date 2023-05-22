//
//  reddio.swift
//  Reddio-SDK-Example
//
//  Created by Yihan Li on 5/22/23.
//

import Foundation
import SwiftUI
import Combine

class ReddioViewModel: ObservableObject {
    @Published var balance: String = ""

    func getBalance() {
        var request = URLRequest(url: URL(string: "https://api-dev.reddio.com/v1/balances?stark_key=0x2209c1318b7021f4938546de573815bd0c5c9de2454e6d1f66766fc345dec80")!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
          print(String(data: data, encoding: .utf8)!)
        }

        task.resume()
        print(balance)
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
