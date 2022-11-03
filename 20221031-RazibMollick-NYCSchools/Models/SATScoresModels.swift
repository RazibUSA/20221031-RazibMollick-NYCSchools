//
//  SATScoresModels.swift
//  20221031-RazibMollick-NYCSchools
//
//  Created by Razib Mollick on 11/3/22.
//

import Foundation

//MARK: - SATScoreModels

struct SATScoreModel: Codable {
    let dbn, schoolName, numOfSatTestTakers, satCriticalReadingAvgScore: String
    let satMathAvgScore, satWritingAvgScore: String
    
    enum CodingKeys: String, CodingKey {
        case dbn
        case schoolName = "school_name"
        case numOfSatTestTakers = "num_of_sat_test_takers"
        case satCriticalReadingAvgScore = "sat_critical_reading_avg_score"
        case satMathAvgScore = "sat_math_avg_score"
        case satWritingAvgScore = "sat_writing_avg_score"
    }
}

typealias SATScoresModels = [SATScoreModel]
