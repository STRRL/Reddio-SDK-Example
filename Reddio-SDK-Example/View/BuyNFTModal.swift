//
//  BuyNFTModal.swift
//  Reddio-SDK-Example
//
//  Created by STRRL on 2023/7/4.
//

import SwiftUI

struct BuyNFTModal: View {
    var contractAddress: String
    var tokenId: String
    var price: String = "0.001"
    var web3Client: Web3Client? = nil
    var afterBuyHook: () -> Void = {}

    var body: some View {
        VStack {
            NFTPreview(
                contractAddress: contractAddress,
                tokenId: tokenId
            )
            Text(price + " ETH")
                .textFieldStyle(.roundedBorder)
                .onSubmit(of: .text) {}

            Button("Buy") {
                Task {
                    do {
                        try await web3Client?.buyNFT(contractAddress: contractAddress, tokenId: tokenId, price: price)
                        afterBuyHook()
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
}

#Preview {
    BuyNFTModal(
        contractAddress: "0x941661bd1134dc7cc3d107bf006b8631f6e65ad5",
        tokenId: "3191",
        web3Client: nil
    )
}
