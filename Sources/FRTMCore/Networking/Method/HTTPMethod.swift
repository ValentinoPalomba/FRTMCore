
//
//  HTTPMethod.swift
//  
//
//  Created by Gemini on 19/08/25.
//

import Foundation

public enum HTTPMethod: String, Sendable {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}
