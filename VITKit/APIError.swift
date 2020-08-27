//
//  APIError.swift
//  VIT
//
//  Created by Aritro Paul on 21/07/20.
//

import Foundation

enum APIError: Error {
    case noResponse(message: String)
    case tooManyRequests(message: String)
    case decodingError(message: String)

    var localizedDescription: String {
        switch self {
        case let .noResponse(message), let .tooManyRequests(message), let .decodingError(message):
            return message
        }
    }
}
