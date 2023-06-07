//
//  ComposedAssetsView.swift
//  Reddio-SDK-Example
//
//  Created by STRRL on 2023/6/6.
//

import SwiftUI

struct ComposedAssetsView: View {
    var web3Client: Web3Client

    @State var selectedAssetType: AssetType = .Layer2

//    @State var layer1ETHBalance = ""
//    @State var layer1ERC20Balance = ""
//    @State var layer1NFTs: [NFT] = []

    @State var isloading = true
    @State var layer2ETHBalance = ""
    @State var layer2ERC20Balance = ""
    @State var layer2NFTs: [NFT] = []

    var body: some View {
        NavigationView {
            VStack {
                if isloading {
                    ProgressView()
                }

                AssetsView(
                    title: .constant(""),
                    ethBalance: $layer2ETHBalance,
                    erc20Balance: $layer2ERC20Balance,
                    nftInventory: $layer2NFTs
                )

                Button("Refresh", action: {
                    Task {
                        isloading = true
                        do {
                            layer2ETHBalance = try await web3Client.fetchLayer2ETHBalance()
                            layer2ERC20Balance = try await web3Client.fetchLayer2ERC20Balance()
                            layer2NFTs = try await web3Client.fetchLayer2NFTs()
                        } catch {
                            print(error)
                        }
                        isloading = false
                    }
                })
            }
        }.task {
            do {
                isloading = true
                layer2ETHBalance = try await web3Client.fetchLayer2ETHBalance()
                layer2ERC20Balance = try await web3Client.fetchLayer2ERC20Balance()
                layer2NFTs = try await web3Client.fetchLayer2NFTs()
            } catch {
                print(error)
            }
            isloading = false
        }
    }
}

struct ComposedAssetsView_Previews: PreviewProvider {
    static var previews: some View {
        ComposedAssetsView(
            web3Client: try! Web3Client(
                ethPrivateKey: "0x12fb12892ff021c7c81bc8e6e2ebd94f5ab14a23d34772024a4511be0bdca937"),
            selectedAssetType: AssetType.Layer2
        )
    }
}
