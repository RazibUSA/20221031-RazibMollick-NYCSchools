//
//  MockDataHelper.swift
//  20221031-RazibMollick-NYCSchoolsTests
//
//  Created by Razib Mollick on 11/3/22.
//

import Foundation
import Combine
import UIKit
@testable import _0221031_RazibMollick_NYCSchools

struct MockNetworkDispatcher: Dispatchable {
    
    let highSchoolModel = HighSchoolNameModel(dbn: "1234", school_name: "My School")
    let satScoreModel = SATScoreModel(dbn: "1234",
                                      schoolName: "My School",
                                      numOfSatTestTakers: "20",
                                      satCriticalReadingAvgScore: "745",
                                      satMathAvgScore: "333",
                                      satWritingAvgScore: "234")
    
    
    func dispatch<T>(with components: URLComponents) -> AnyPublisher<T, NetworkServiceError> where T : Decodable, T : Encodable {
        
        var schoolNamePublisher = Just([highSchoolModel] as! T)
            .setFailureType(to: NetworkServiceError.self)
            .eraseToAnyPublisher()
        
        if T.self == [SATScoreModel].self {
            schoolNamePublisher = Just([satScoreModel] as! T)
                        .setFailureType(to: NetworkServiceError.self)
                        .eraseToAnyPublisher()
        }
        
        return schoolNamePublisher
    }
    

}


