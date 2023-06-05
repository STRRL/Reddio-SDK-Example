//
//  NFTSummary.swift
//  Reddio-SDK-Example
//
//  Created by STRRL on 2023/6/5.
//

import SwiftUI

struct NFTPreview: View {
    var contractAddress: String
    var tokenId: String

    @State private var imageUrl: String

    init(contractAddress: String, tokenId: String) {
        self.contractAddress = contractAddress
        self.tokenId = tokenId
        imageUrl = ""
    }

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: imageUrl)!).scaledToFit()
            Text("Token ID: \(tokenId)")
        }.task {
            do {
                self.imageUrl = try await fetchNFTMetaData(contractAddress: self.contractAddress, tokenId: self.tokenId)
            } catch {}
        }
    }
}

struct NFTSummary_Previews: PreviewProvider {
    static var previews: some View {
        NFTPreview(
            contractAddress: "0x941661bd1134dc7cc3d107bf006b8631f6e65ad5",
            tokenId: "3191"
        )
    }
}
