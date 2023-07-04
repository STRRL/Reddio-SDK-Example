//
//  SelllNFTModal.swift
//  Reddio-SDK-Example
//
//  Created by STRRL on 2023/6/29.
//

import SwiftUI

struct SelllNFTModal: View {
    var contractAddress: String
    var tokenId: String
    var web3Client: Web3Client? = nil
    var afterSellHook: () -> Void = {}
    @State private var price: String = "0.001"

    var body: some View {
        VStack {
            NFTPreview(
                contractAddress: contractAddress,
                tokenId: tokenId
            )
            TextField("price", text: $price)
                .textFieldStyle(.roundedBorder)
                .onSubmit(of: .text) {}

            Button("Sell") {
                Task {
                    do {
                        try await web3Client?.sellNFT(contractAddress: contractAddress, tokenId: tokenId, price: price)
                        afterSellHook()
                    } catch {
                        print(error)
                    }
                }
            }
            .buttonStyle(.borderedProminent)
            .padding(.top, 20)
        }
        .padding()
    }

    func sellNFT(price: String) async {
        do {
            try await web3Client!.sellNFT(
                contractAddress: contractAddress,
                tokenId: tokenId,
                price: price
            )
        } catch {
            print(error)
        }
    }
}

#Preview {
    SelllNFTModal(
        contractAddress: "0x941661bd1134dc7cc3d107bf006b8631f6e65ad5",
        tokenId: "3191",
        web3Client: nil
    )
}
