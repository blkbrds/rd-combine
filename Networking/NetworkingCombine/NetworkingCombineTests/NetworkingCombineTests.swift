//
//  NetworkingCombineTests.swift
//  NetworkingCombineTests
//
//  Created by MBP0051 on 4/27/21.
//

import XCTest
@testable import NetworkingCombine

class NetworkingCombineTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    override class func setUp() {
        super.setUp()

    }

    func testCase400() throws {
        let networkManager: CocktailNetworkManager = CocktailNetworkManager(provider: MockProviderClient<CocktailService>())
        _ = networkManager.getCocktails(name: "A")
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
            } receiveValue: { (value) in
                XCTAssertEqual(value.data?.count, 2)
            }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
