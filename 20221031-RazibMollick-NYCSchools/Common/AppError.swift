//
//  AppError.swift
//  20221031-RazibMollick-NYCSchools
//
//  Created by Razib Mollick on 11/1/22.
//

import Foundation

public enum AppError: Error {
    case failToLoad(Error)
    case networkError(String)
    
    public var description: String {
        switch self {
        case .failToLoad(let error):
            return "Fail To load Data: \(error.localizedDescription)\n, Pull to refresh."
        case .networkError(let errorText):
            return "Network Error: \(errorText)"
        }
    }
}
