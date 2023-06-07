//
//  AssetsView.swift
//  Reddio-SDK-Example
//
//  Created by STRRL on 2023/6/5.
//

import SwiftUI

struct AssetsView: View {
    @Binding var title: String
    @Binding var ethBalance: String
    @Binding var erc20Balance: String
    @Binding var nftInventory: [NFT]

    var body: some View {
        List {
            Section {
                Text("GoerliETH Balance")
                Text("\(ethBalance)")
            }

            Section {
                Text("ERC20 Balance")
                Text("\(erc20Balance)")
            }

            Section {
                Text("NFTs")
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top) {
                        ForEach(nftInventory, id: \NFT.tokenId) { item in
                            NFTPreview(
                                contractAddress: item.contractAddress,
                                tokenId: item.tokenId
                            )
                        }
                    }
                }
            }
        }.navigationTitle(title)
    }
}

struct AssetsView_Previews: PreviewProvider {
    static var previews: some View {
        AssetsView(
            title: .constant("Layer X Assets"),
            ethBalance: .constant("0.0041"),
            erc20Balance: .constant("400.0"),
            nftInventory: .constant([
                NFT(contractAddress: "0x941661bd1134dc7cc3d107bf006b8631f6e65ad5", tokenId: "3"),
                NFT(contractAddress: "0x941661bd1134dc7cc3d107bf006b8631f6e65ad5", tokenId: "4"),
                NFT(contractAddress: "0x941661bd1134dc7cc3d107bf006b8631f6e65ad5", tokenId: "6"),
                NFT(contractAddress: "0x941661bd1134dc7cc3d107bf006b8631f6e65ad5", tokenId: "8"),
            ])
        )
    }
}
