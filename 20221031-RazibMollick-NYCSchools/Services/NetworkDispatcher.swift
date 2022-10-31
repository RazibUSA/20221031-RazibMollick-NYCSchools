//
//  NetworkDispatcher.swift
//  20221031-RazibMollick-NYCSchools
//
//  Created by Razib Mollick on 10/29/22.
//

import Combine
import Foundation

struct NetworkDispatcher {
    
    private let urlSession: URLSession
    
    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    /// Dispatches an URLRequest and returns a publisher
    func dispatch<T: Codable>(with components: URLComponents) -> AnyPublisher<T, NetworkServiceError> {
        
        guard let request = components.url else {
            let error = NetworkServiceError.badRequest
              return Fail(error: error).eraseToAnyPublisher()
            }
        
        return urlSession
            .dataTaskPublisher(for: request)
            // Map on Request response
            .tryMap({ data, response in
                // If the response is invalid, throw an error
                if let response = response as? HTTPURLResponse,
                   !(200...299).contains(response.statusCode) {
                    throw httpError(response.statusCode)
                }
                // Return Response data
                return data
            })
            // Decode data using our ReturnType
            .decode(type: T.self, decoder: JSONDecoder())
            // Handle any decoding errors
            .mapError { error in
                handleError(error)
            }
            // And finally, expose our publisher
            .eraseToAnyPublisher()
    }
    
    /// Parses a HTTP StatusCode and returns a proper error
    private func httpError(_ statusCode: Int) -> NetworkServiceError {
        switch statusCode {
        case 400: return .badRequest
        case 401: return .unauthorized
        case 403: return .forbidden
        case 404: return .notFound
        case 402, 405...499: return .error4xx(statusCode)
        case 500: return .serverError
        case 501...599: return .error5xx(statusCode)
        default: return .unknownError
        }
    }
    
    /// Parses URLSession Publisher errors and return proper ones
    /// - Parameter error: URLSession publisher error
    /// - Returns: Readable NetworkRequestError
    private func handleError(_ error: Error) -> NetworkServiceError {
        switch error {
        case is Swift.DecodingError:
            return .decodingError(error.localizedDescription)
        case let urlError as URLError:
            return .urlSessionFailed(urlError)
        case let error as NetworkServiceError:
            return error
        default:
            return .unknownError
        }
    }
}
