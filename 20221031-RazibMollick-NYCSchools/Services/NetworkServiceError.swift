//
//  NetworkServiceError.swift
//  20221031-RazibMollick-NYCSchools
//
//  Created by Razib Mollick on 10/29/22.
//

import Foundation

// MARK: - Error Types

enum NetworkServiceError: LocalizedError, Equatable {
    case badRequest
    case decodingError(_ description: String)
    case forbidden
    case error4xx(_ code: Int)
    case error5xx(_ code: Int)
    case invalidRequest
    case notFound
    case unauthorized
    case urlSessionFailed(_ error: URLError)
    case unknownError
    case serverError
}
