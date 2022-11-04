//
//  SchoolDataFetcherTests.swift
//  20221031-RazibMollick-NYCSchoolsTests
//
//  Created by Razib Mollick on 11/4/22.
//

import XCTest
@testable import _0221031_RazibMollick_NYCSchools

final class SchoolDataFetcherTests: XCTestCase {
    
    var dataFetcher: SchoolDataFetcher!

    override func setUpWithError() throws {
        dataFetcher = SchoolDataFetcher(networkDispatcher: MockNetworkDispatcher() as Dispatchable)
    }

    func testGetHighSchoolNames() throws {
        let expectation = XCTestExpectation(description: "School Names Request Test")
        
        _ = dataFetcher.getHighSchoolNames()
            .sink(receiveCompletion: { _ in}) { response  in
//                let model = try XCTUnwrap(response.first)
                XCTAssertEqual(response.first?.dbn, "1234")
                expectation.fulfill()
            }
        
        wait(for: [expectation], timeout: 1)
    }

    // Similary we can test below
    // getSATScores()
    //makeHighSchoolNamesComponents()

}
