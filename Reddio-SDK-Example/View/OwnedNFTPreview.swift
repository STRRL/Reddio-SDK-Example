//
//  OwnedNFTPreview.swift
//  Reddio-SDK-Example
//
//  Created by STRRL on 2023/6/28.
//

import SwiftUI

struct OwnedNFTPreview: View {
    var contractAddress: String
    var tokenId: String
    var onSellButtonClick: (String, String) -> Void = { _, _ in }

    var body: some View {
        VStack {
            NFTPreview(contractAddress: contractAddress, tokenId: tokenId)

            Button(action: {
                onSellButtonClick(contractAddress, tokenId)
            }, label: {
                Text("Sell")
            }).buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    NavigationView(content: {
        OwnedNFTPreview(
            contractAddress: "0x941661bd1134dc7cc3d107bf006b8631f6e65ad5",
            tokenId: "3191"
        )
    })
}
