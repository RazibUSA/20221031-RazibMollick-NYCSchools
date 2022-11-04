//
//  HighSchoolNamesDataSource.swift
//  20221031-RazibMollick-NYCSchools
//
//  Created by Razib Mollick on 10/31/22.
//

import Foundation
import Combine

// MARK: View Model in MVVM-C
class HighSchoolNamesDataSource {
    var dataSource: [HighSchoolNameModel] = []
    var scoresModels: SATScoresModels?
    private let dataFetcher: SchoolDataFetcher
    private var cancellables = Set<AnyCancellable>()
    
    init(scoresModels: SATScoresModels? = nil, dataFetcher: SchoolDataFetcher, cancellables: Set<AnyCancellable> = Set<AnyCancellable>()) {
        self.scoresModels = scoresModels
        self.dataFetcher = dataFetcher
        self.cancellables = cancellables
    }
    
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
    
    func requestScores(with dbn: String? = nil, completionHandler: @escaping (Error?) -> Void) {
        dataFetcher.getSATScores(by: dbn)
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
            }, receiveValue: { scores in
                self.scoresModels = scores
            }).store(in: &cancellables)
    }
}
