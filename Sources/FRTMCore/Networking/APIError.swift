
//
//  APIError.swift
//
//
//  Created by Gemini on 19/08/25.
//

import Foundation

public enum APIError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case statusCode(Int)
    case noData
    case decodingFailed(Error)
}
