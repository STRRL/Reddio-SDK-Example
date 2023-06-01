//
//  Reddio_SDK_ExampleTests.swift
//  Reddio-SDK-ExampleTests
//
//  Created by Yihan Li on 5/18/23.
//

@testable import Reddio_SDK_Example
import XCTest

final class Reddio_SDK_ExampleTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testTryOrderInfo() async throws {
        let info = try await orderInfo(starkKey: "0x13a69a1b7a5f033ee2358ebb8c28fd5a6b86d42e30a61845d655d3c7be4ad0e", contract1: "0x941661bd1134dc7cc3d107bf006b8631f6e65ad5", contract2: "ETH")
        print(info)
    }
}
