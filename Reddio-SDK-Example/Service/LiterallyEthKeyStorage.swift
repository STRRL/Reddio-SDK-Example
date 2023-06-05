//
//  LiterallyEthKeyStorage.swift
//  Reddio-SDK-Example
//
//  Created by STRRL on 2023/6/5.
//

import Foundation
import web3

class LiterallyEthKeyStorage: EthereumKeyStorageProtocol {
    init(ethPrivateKey: String) {
        self.ethPrivateKey = ethPrivateKey
    }

    var ethPrivateKey: String

    func storePrivateKey(key _: Data) throws {
        throw EthereumKeyStorageError.failedToSave
    }

    func loadPrivateKey() throws -> Data {
        return Data(hex: ethPrivateKey)
    }
}
