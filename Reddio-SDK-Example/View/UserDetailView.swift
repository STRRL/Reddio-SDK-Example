import SwiftUI
import web3
import Web3Auth

struct UserDetailView: View {
    @State var user: Web3AuthState?
    @Binding var loggedIn: Bool
    @State private var showingAlert = false
    @State private var nftTokenIdToBuy = ""
    @State private var nftPriceToBuy = ""

    @StateObject var web3RPC: Web3RPC
    @ObservedObject var reddioViewModel = ReddioViewModel()

    var body: some View {
        if let user = user {
            List {
                Section {
                    Text("\(user.privKey ?? "")")
                } header: {
                    Text("Private key")
                }
                Section {
                    Button {
                        web3RPC.getAccounts()

                    } label: {
                        HStack {
                            Text("Get Public Address")
                            Spacer()
                        }
                    }
                    if web3RPC.publicAddress != "" {
                        Text("\(web3RPC.publicAddress)")
                    }

                } header: {
                    Text("Public key")
                }
                Section {
                    Text("Name: \(user.userInfo?.name ?? "")")
                    Text("Email: \(user.userInfo?.email ?? "")")
                }
                header: {
                    Text("User Info")
                }
                Section {
                    Button {
                        web3RPC.getBalance()

                    } label: {
                        HStack {
                            Text("Get Balance on layer1")
                            Spacer()
                        }
                    }
                    if web3RPC.balance >= 0 {
                        Text("\(web3RPC.balance) ETH")
                    }

//                    generate starkey
                    Button {
                        web3RPC.signStructuredMessage(message: "Generate layer 2 key")

                        reddioViewModel.generatestarkey(signature: web3RPC.signedMessageHashString)
                    } label: {
                        HStack {
                            Text("Generate Starkey")
                            Spacer()
                        }
                    }

                    Text("stark private key: \(reddioViewModel.starkPrivateKey)")
                    Text("stark key: \(reddioViewModel.starkPublicKey)")

//                    get balance through reddio api
                    Button {
                        reddioViewModel.getBalance()
                    } label: {
                        HStack {
                            Text("Get Balance on layer2")
                            Spacer()
                        }
                    }

//                    display the assets on starkex
                    ForEach(reddioViewModel.assets) { asset in
                        VStack(alignment: .leading) {
                            Text("\(asset.displayValue) \(asset.symbol)")
                        }
                    }

                    TextField("Buy REDDIO721, TokenID", text: $nftTokenIdToBuy)
                    TextField("Expected Buy Price", text: $nftPriceToBuy)

//                     order NFT through reddio api
                    Button {
                        reddioViewModel.buyREDDIO721NFT(tokenId: nftTokenIdToBuy, price: nftPriceToBuy)
//                        reddioViewModel.orderNFT()
                    } label: {
                        HStack {
                            Text("Buy NFT on layer2")
                            Spacer()
                        }
                    }
                }
                header: {
                    Text("Blockchain Calls")
                }

                Button {
                    Task.detached {
                        do {
                            try await Web3Auth(.init(clientId: "BKH8KHpluUwzrDKv6BVDzQ6TByyp8MbotXAyDfOwu9QrHiHE-Iv9dO7X4FGzn8SueD19i72uBu37NJvxOR1-gyE",
                                                     network: .cyan)).logout()
                            await MainActor.run(body: {
                                loggedIn.toggle()
                            })
                        } catch {
                            DispatchQueue.main.async {
                                showingAlert = true
                            }
                        }
                    }
                } label: {
                    Text("Logout")
                        .foregroundColor(.red)
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Error"), message: Text("Logout failed!"), dismissButton: .default(Text("OK")))
                }
            }
            .listStyle(.automatic)
        }
    }
}

// struct UserDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        let user: Web3AuthState = .init(privKey: "12345", ed25519PrivKey: "32334", sessionId: "23234384y7735y47shdj", userInfo: nil, error: nil)
//        UserDetailView(user: user , loggedIn: .constant(true), web3RPC: .init(user: user)!)
//    }
// }
