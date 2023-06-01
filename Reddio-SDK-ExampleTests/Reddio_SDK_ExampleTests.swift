//
//  Reddio_SDK_ExampleTests.swift
//  Reddio-SDK-ExampleTests
//
//  Created by Yihan Li on 5/18/23.
//

@testable import Reddio_SDK_Example
import XCTest

final class Reddio_SDK_ExampleTests: XCTestCase {
    func testTryOrderInfo() async throws {
        let info = try await getOrderInfo(starkKey: "0x13a69a1b7a5f033ee2358ebb8c28fd5a6b86d42e30a61845d655d3c7be4ad0e", contract1: "ERC721:0x941661bd1134dc7cc3d107bf006b8631f6e65ad5", contract2: "ETH:ETH")
        print(info)
    }

    func testTryContractInfo() async throws {
        let info = try await getContractInfo(type: "ETH", contractAddress: "ETH")
        print(info)
    }

    func testTryQuantizedAmount() async throws {
        let out = try await quantizedAmount(amount: "0.1", type: "eth", contractAddress: "eth")
        print(out)
    }
}
