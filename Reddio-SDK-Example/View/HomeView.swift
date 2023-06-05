//
//  HomeView.swift
//  Reddio-SDK-Example
//
//  Created by STRRL on 2023/6/5.
//

import SwiftUI

struct HomeView: View {
    @State private var selection: Tab = .marketplace

    enum Tab {
        case account
        case assets
        case marketplace
    }

    var body: some View {
        TabView(selection: $selection) {
            Text("Marketplace View")
                .tabItem {
                    Label("Marketplace", systemImage: "cart")
                }
                .tag(Tab.marketplace)

            Text("Assets View")
                .tabItem {
                    Label("Assets", systemImage: "dollarsign.circle")
                }
                .tag(Tab.assets)

            AccountView(
                web3Client: try! Web3Client(
                    ethPrivateKey: "0x12fb12892ff021c7c81bc8e6e2ebd94f5ab14a23d34772024a4511be0bdca937")
            )
            .tabItem {
                Label("Account", systemImage: "person.circle")
            }
            .tag(Tab.account)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
