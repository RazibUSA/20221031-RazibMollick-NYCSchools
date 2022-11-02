//
//  HighSchoolNamesDataSource.swift
//  20221031-RazibMollick-NYCSchools
//
//  Created by Razib Mollick on 10/31/22.
//

import Foundation
import Combine

class HighSchoolNamesDataSource {
    var dataSource: [HighSchoolNameModel] = []
    private let dataFetcher = SchoolDataFetcher()
    private var cancellables = Set<AnyCancellable>()
    
    func requestSchoolNames(completionHandler: @escaping (Error?) -> Void) {
        dataFetcher.getHighSchoolNames()
            .sink(receiveCompletion: { [weak self] value in
                guard let self = self else { return }
                
                switch value {
                case let .failure(error):
                    debugPrint(error.localizedDescription)
                    self.dataSource = []
                    DispatchQueue.main.async {
                        completionHandler(AppError.failToLoad(error))
                    }
                case .finished:
                    completionHandler(nil)
                    break
                }
            }, receiveValue: { schoolNames in
                self.dataSource = schoolNames
            }).store(in: &cancellables)
    }
}
