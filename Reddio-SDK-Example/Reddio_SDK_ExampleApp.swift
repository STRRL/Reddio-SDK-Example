//
//  Reddio_SDK_ExampleApp.swift
//  Reddio-SDK-Example
//
//  Created by Yihan Li on 5/18/23.
//

import SwiftUI
import Web3Auth

@main
struct MainApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView(
                web3Client: try! Web3Client(
                    ethPrivateKey: "0x12fb12892ff021c7c81bc8e6e2ebd94f5ab14a23d34772024a4511be0bdca937")
            )
        }
    }
}
