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
            ContentView(vm: ViewModel())
        }
    }
}
