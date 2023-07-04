//
//  MarketplaceView.swift
//  Reddio-SDK-Example
//
//  Created by STRRL on 2023/6/5.
//

import SwiftUI

struct MarketplaceView: View {
    @State var selfStarKey: String = ""
    var web3Client: Web3Client? = nil
    @State var forSaleNFTs: [ForSaleNFT] = []

    @State private var buyModalActive: Bool = false
    @State private var nftToBuyAddress: String? = nil
    @State private var nftToBuyTokenId: String? = nil
    @State private var nftToBuyPrice: String? = nil

    var body: some View {
        // bypass https://developer.apple.com/forums/thread/659660
        let _ = buyModalActive
        return ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 130), spacing: 16, alignment: .top)], alignment: .center, spacing: 16) {
                ForEach(forSaleNFTs) { item in
                    ForSaleNFTPreview(
                        contractAddress: item.symbol.quoteTokenContractAddr,
                        tokenId: item.tokenId,
                        price: item.displayPrice,
                        onBuyButtonClick: { contractAddress, tokenId, price in
                                nftToBuyAddress = contractAddress
                                nftToBuyTokenId = tokenId
                                nftToBuyPrice = price
                                buyModalActive = true
                        }
                    ).padding()
                }
            }
        }
        .refreshable {
            do {
                try await refresh()
            } catch {
                print(error)
            }
        }
        .sheet(isPresented: $buyModalActive, content: {
            if buyModalActive,
               nftToBuyAddress != nil,
               nftToBuyTokenId != nil,
               nftToBuyPrice != nil
            {
                BuyNFTModal(
                    contractAddress: nftToBuyAddress!,
                    tokenId: nftToBuyTokenId!,
                    price: nftToBuyPrice!,
                    web3Client: web3Client,
                    afterBuyHook: {
                        self.buyModalActive = false
                        Task{
                            do{
                               try await refresh()
                            }catch{
                                print(error)
                            }
                        }
                    }
                )
                .presentationDetents([.fraction(0.5)])
                .padding()
            } else {
                Text("nothing")
                Text(nftToBuyAddress ?? "")
                Text(nftToBuyTokenId ?? "")
                Text(nftToBuyPrice ?? "")
            }
        })
        .task {
            do {
                let starkKey = try web3Client?.getStarkPublicKey()
                selfStarKey = starkKey ?? ""
            } catch {
                print(error)
            }

            do {
                try await refresh()
            } catch {
                print(error)
            }
        }
        .padding()
    }

    func refresh() async throws {
        let result = try await listForSaleNFT(contractAddress: "0x941661bd1134dc7cc3d107bf006b8631f6e65ad5")
        forSaleNFTs = result.filter { item in
            item.starkKey != selfStarKey
                && item.direction == 0
                && item.symbol.baseTokenName == "ETH"
        }
    }
}

struct MarketplaceView_Previews: PreviewProvider {
    static var previews: some View {
        MarketplaceView()
    }
}
