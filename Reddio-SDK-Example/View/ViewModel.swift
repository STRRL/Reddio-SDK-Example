import Foundation
import Web3Auth

class ViewModel: ObservableObject {
    var web3Auth: Web3Auth?
    @Published var loggedIn: Bool = false
    @Published var user: Web3AuthState?
    @Published var isLoading = false
    @Published var navigationTitle: String = ""
    private var clientId = "BKH8KHpluUwzrDKv6BVDzQ6TByyp8MbotXAyDfOwu9QrHiHE-Iv9dO7X4FGzn8SueD19i72uBu37NJvxOR1-gyE"
    private var network: Network = .cyan
    func setup() async {
        guard web3Auth == nil else { return }
        await MainActor.run(body: {
            isLoading = true
            navigationTitle = "Loading"
        })
        web3Auth = await Web3Auth(.init(clientId: clientId, network: network))
        await MainActor.run(body: {
            if self.web3Auth?.state != nil {
                user = web3Auth?.state
                loggedIn = true
            }
            isLoading = false
            navigationTitle = loggedIn ? "UserInfo" : "SignIn"
        })
    }

    func login(provider: Web3AuthProvider) {
        Task {
            do {
                let result = try await Web3Auth(.init(clientId: clientId, network: network)).login(W3ALoginParams(loginProvider: provider))
                await MainActor.run(body: {
                    user = result
                    loggedIn = true
                })

            } catch {
                print("Error")
            }
        }
    }

    func loginEmailPasswordless(provider: Web3AuthProvider, email: String) {
        Task {
            do {
                let result = try await Web3Auth(.init(clientId: clientId, network: network)).login(W3ALoginParams(loginProvider: provider, extraLoginOptions: ExtraLoginOptions(display: nil, prompt: nil, max_age: nil, ui_locales: nil, id_token_hint: nil, id_token: nil, login_hint: email, acr_values: nil, scope: nil, audience: nil, connection: nil, domain: nil, client_id: nil, redirect_uri: nil, leeway: nil, verifierIdField: nil, isVerifierIdCaseSensitive: nil)))
                await MainActor.run(body: {
                    user = result
                    loggedIn = true
                    navigationTitle = "UserInfo"
                })

            } catch {
                print("Error")
            }
        }
    }

    func whitelabelLogin() {
        Task.detached { [unowned self] in
            do {
                web3Auth = await Web3Auth(W3AInitParams(
                    clientId: clientId,
                    network: network,
                    whiteLabel: W3AWhiteLabelData(
                        name: "Web3Auth iOS Example",
                        dark: true, theme: ["primary": "#123456"]
                    )
                ))
                let result = try await web3Auth?
                    .login(W3ALoginParams(loginProvider: .GOOGLE))
                await MainActor.run(body: {
                    user = result
                    loggedIn = true
                })
            } catch {
                print(error)
            }
        }
    }
}

extension ViewModel {
    func showResult(result: Web3AuthState) {
        print("""
        Signed in successfully!
            Private key: \(result.privKey ?? "")
                Ed25519 Private key: \(result.ed25519PrivKey ?? "")
            User info:
                Name: \(result.userInfo?.name ?? "")
                Profile image: \(result.userInfo?.profileImage ?? "N/A")
                Type of login: \(result.userInfo?.typeOfLogin ?? "")
        """)
    }
}
