//
//  APIErrorType.swift
//  QuantumSitTask
//
//  Created by Yousef on 12/9/20.
//

import Foundation

enum APIError: Error {
    case unAuthenticated(data: Data?)
    case unAuthorized(data: Data?)
    case notFound(data: Data?)
    case methodNotAllowed(data: Data?)
    case internalServerError(data: Data?)
    case other(statusCode: Int, data: Data?, error: Error?)
    case decodingFailed(error: Error?)
    case invalidURL(url: String)
    
    init(rawValue: Int, data: Data?) {
        switch rawValue {
        case 200:
            self = .decodingFailed(error: nil)
        case 401:
            self = .unAuthenticated(data: data)
        case 403:
            self = .unAuthorized(data: data)
        case 404:
            self = .notFound(data: data)
        case 405:
            self = .methodNotAllowed(data: data)
        case 500:
            self = .internalServerError(data: data)
        default:
            self = .other(statusCode: rawValue, data: data, error: nil)
        }
    }
    
}
