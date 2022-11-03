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
    func getSATScores(by dnb: String?) -> AnyPublisher<[SATScoreModel], NetworkServiceError>
}

struct SchoolDataFetcher {
    
    private var networkDispatcher: NetworkDispatcher
    
    init(networkDispatcher: NetworkDispatcher = NetworkDispatcher()) {
        self.networkDispatcher = networkDispatcher
    }
}

extension SchoolDataFetcher: SchoolDataFetchable {
    func getSATScores(by dnb: String?) -> AnyPublisher<[SATScoreModel], NetworkServiceError> {
        return networkDispatcher.dispatch(with: makeSATScoreComponents(dnb))
    }
    
    func getHighSchoolNames() -> AnyPublisher<[HighSchoolNameModel], NetworkServiceError> {
        return networkDispatcher.dispatch(with: makeHighSchoolNamesComponents())
    }
}

private extension SchoolDataFetcher {
    struct APIConfig {
        static let scheme = "https"
        static let host = "data.cityofnewyork.us"
        static let path = "/resource/s3k6-pzi2.json"
        static let satPath = "/resource/f9bf-2cp4.json"
        static let token = "QpXLUwDP2ln7ho7iKVVicwnpF"
      }
      
      func makeHighSchoolNamesComponents() -> URLComponents {
        var components = URLComponents()
        components.scheme = APIConfig.scheme
        components.host = APIConfig.host
        components.path = APIConfig.path
        
        components.queryItems = [
            URLQueryItem(name: "$$app_token", value: APIConfig.token)
        ]
        
        return components
      }
    
    func makeSATScoreComponents(_ dbn: String? = nil) -> URLComponents {
      var components = URLComponents()
      components.scheme = APIConfig.scheme
      components.host = APIConfig.host
      components.path = APIConfig.satPath
      
      components.queryItems = [
          URLQueryItem(name: "$$app_token", value: APIConfig.token)
      ]
    
        if let number = dbn {
            components.queryItems?.append(URLQueryItem(name: "dbn", value: number))
        }
      
      return components
    }
}
