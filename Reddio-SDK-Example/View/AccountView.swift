//
//  AccountView.swift
//  Reddio-SDK-Example
//
//  Created by STRRL on 2023/6/5.
//

import SwiftUI

struct AccountView: View {
    var web3Client: Web3Client

    @State var ethAddress: String = ""
    @State var starkKey: String = ""

    @State var ethPrivateKey: String = ""
    @State var starkPrivateKey: String = ""

    var body: some View {
        NavigationView {
            List {
                Section {
                    Text("ETH Addresss")
                    Text("\(ethAddress)")
                }

                Section {
                    Text("Stark Key")
                    Text("\(starkKey)")
                }

                Section {
                    Text("ETH Private Key")
                    SecureInputView("", text: $ethPrivateKey)
                }

                Section {
                    Text("Stark Private Key")
                    SecureInputView("", text: $starkPrivateKey)
                }
            }.navigationTitle("Account")

        }.task {
            do {
                self.ethAddress = self.web3Client.getAddress().value
                self.starkKey = try self.web3Client.getStarkPublicKey()
                self.ethPrivateKey = self.web3Client.getEthPrivateKey()
                self.starkPrivateKey = try self.web3Client.getStarkPrivateKey()
            } catch {}
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView(
            web3Client: try! Web3Client(
                ethPrivateKey: "0x12fb12892ff021c7c81bc8e6e2ebd94f5ab14a23d34772024a4511be0bdca937")
        )
    }
}

struct SecureInputView: View {
    @Binding private var text: String
    @State private var isSecured: Bool = true
    private var title: String

    init(_ title: String, text: Binding<String>) {
        self.title = title
        _text = text
    }

    var body: some View {
        ZStack(alignment: .trailing) {
            Group {
                if isSecured {
                    SecureField(title, text: $text)
                } else {
                    TextField(title, text: $text)
                }
            }.padding(.trailing, 32)

            Button(action: {
                isSecured.toggle()
            }) {
                Image(systemName: self.isSecured ? "eye.slash" : "eye")
                    .accentColor(.gray)
            }
        }
    }
}
