//
//  HighSchoolListViewControllerTests.swift
//  20221031-RazibMollick-NYCSchoolsTests
//
//  Created by Razib Mollick on 11/4/22.
//

import XCTest
@testable import _0221031_RazibMollick_NYCSchools

//Test Suite 'HighSchoolListViewControllerTests' passed at 2022-11-04 07:02:16.884.
//Executed 2 tests, with 0 failures (0 unexpected) in 0.077 (0.080) seconds

final class HighSchoolListViewControllerTests: XCTestCase {
    var sut: HighSchoolListViewController!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let mockNetworkDispacher = MockNetworkDispatcher()
        sut = HighSchoolListViewController(coordinator: MockCoordinator(),
                                           dataFatcher: SchoolDataFetcher(networkDispatcher: mockNetworkDispacher))
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        sut = nil
    }
    
    private func loadViewController() throws {
        let navigationController = UINavigationController(rootViewController: sut)
        let window = UIWindow()
        window.rootViewController = sut
        window.makeKeyAndVisible()
        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()
        sut.viewWillAppear(true)
    }

    func testViewControllerView() throws {
        XCTAssertNotNil(sut.view)
    }
    
    func testViewElements() throws {
        try loadViewController()
        
        XCTAssertNotNil(sut.navigationController)
        sut.testHooks.makeSchoolNamesRequest()
        XCTAssertEqual(sut.testHooks.dataSource.dataSource.first?.dbn, "1234")
    }
}

class MockCoordinator: BaseCoordinator<Void> {
    // TBD: - expand based on the requirement.
}
