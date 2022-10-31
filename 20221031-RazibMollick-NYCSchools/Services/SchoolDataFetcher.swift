//
//  SchoolDataFetcher.swift
//  20221031-RazibMollick-NYCSchools
//
//  Created by Razib Mollick on 10/30/22.
//

import Combine
import Foundation

protocol SchoolDataFetchable{
    func getHighSchoolNames() -> AnyPublisher<[HighSchoolNameModel], NetworkServiceError>
}

struct SchoolDataFetcher {
    
    private var networkDispatcher: NetworkDispatcher
    
    init(networkDispatcher: NetworkDispatcher = NetworkDispatcher()) {
        self.networkDispatcher = networkDispatcher
    }
}


extension SchoolDataFetcher: SchoolDataFetchable {
    func getHighSchoolNames() -> AnyPublisher<[HighSchoolNameModel], NetworkServiceError> {
        return networkDispatcher.dispatch(with: makeHighSchoolNamesComponents())
    }
}

private extension SchoolDataFetcher {
    struct APIConfig {
        static let scheme = "https"
        static let host = "data.cityofnewyork.us"
        static let path = "/resource/s3k6-pzi2.json"
        static let token = "QpXLUwDP2ln7ho7iKVVicwnpF"
      }
      
      func makeHighSchoolNamesComponents() -> URLComponents {
        var components = URLComponents()
        components.scheme = APIConfig.scheme
        components.host = APIConfig.host
        components.path = APIConfig.path
        
        components.queryItems = [
            URLQueryItem(name: "$$app_token", value: APIConfig.token),
        ]
        
        return components
      }
}
