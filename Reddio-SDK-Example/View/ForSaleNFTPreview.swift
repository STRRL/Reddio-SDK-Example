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
    var price: String = "0.001"
    var onBuyButtonClick: (String, String, String) -> Void = { _, _, _ in }

    var body: some View {
        VStack {
            NFTPreview(contractAddress: contractAddress, tokenId: tokenId)
            Text(price + " ETH")
            Button(action: {
                onBuyButtonClick(contractAddress, tokenId, price)
            }, label: {
                Text("Buy")
            }).buttonStyle(.borderedProminent)
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
