//
//  NetworkDispatcherTests.swift
//  20221031-RazibMollick-NYCSchoolsTests
//
//  Created by Razib Mollick on 11/3/22.
//

import XCTest
@testable import _0221031_RazibMollick_NYCSchools

//Test Suite 'NetworkDispatcherTests' passed at 2022-11-04 03:33:30.973.
//     Executed 2 tests, with 0 failures (0 unexpected) in 0.004 (0.007) seconds

final class NetworkDispatcherTests: XCTestCase {

    func testHttpError() throws {
        let networkDispatch = NetworkDispatcher()
        
        // Simple Demo test
        XCTAssertEqual(networkDispatch.testHooks.httpError(400), .badRequest)
        // TBD
    }
    
    func testHandleError() throws {
        let error = NetworkServiceError.decodingError("error Test")
        let networkDispatch = NetworkDispatcher()
        
        // Simple Demo test
        XCTAssertEqual(networkDispatch.testHooks.handleError(error), .decodingError("error Test"))
        // TBD
    }
}
