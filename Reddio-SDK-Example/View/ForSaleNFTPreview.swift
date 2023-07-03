//
//  ForSaleNFTPreview.swift
//  Reddio-SDK-Example
//
//  Created by STRRL on 2023/6/28.
//

import SwiftUI

struct ForSaleNFTPreview: View {
    var contractAddress: String
    var tokenId: String
    var price: String
    var web3Client: Web3Client?

    init(contractAddress: String, tokenId: String, price: String, web3Client: Web3Client? = nil) {
        self.contractAddress = contractAddress
        self.tokenId = tokenId
        self.price = price
        self.web3Client = web3Client
    }

    var body: some View {
        VStack {
            NFTPreview(contractAddress: contractAddress, tokenId: tokenId)
            Text(price + " ETH")
            Button(action: {
                let task = Task {
                    if web3Client == nil {
                        return
                    }
                    do {
                        try await web3Client!.buyNFT(contractAddress: contractAddress, tokenId: tokenId, price: price)
                    } catch {}
                }

            }, label: {
                Text("Buy")
            }).buttonStyle(.bordered)
        }
    }
}

#Preview {
    ForSaleNFTPreview(
        contractAddress: "0x941661bd1134dc7cc3d107bf006b8631f6e65ad5",
        tokenId: "3191",
        price: "0.001"
    )
}
