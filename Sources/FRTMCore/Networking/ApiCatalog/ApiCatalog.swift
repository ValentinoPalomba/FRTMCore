//
//  ApiCatalog.swift
//  FRTMCore
//
//  Created by PALOMBA VALENTINO on 19/08/25.
//

import Foundation

public protocol ApiCatalog<Input, Output>: Sendable {
    associatedtype Input: Codable & Sendable
    associatedtype Output: Codable & Sendable
    var host: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
}


public extension ApiCatalog {
    func request(input: Input) -> DataRequest<Input, Output> {
        return .init(
            host: host,
            path: path,
            method: method,
            input: input,
            outputType: Output.self
        )
    }
}


public struct DataRequest<Input: Sendable & Codable, Output: Sendable & Codable>: Sendable {
    var host: String
    var path: String
    var method: HTTPMethod
    var input: Input
    var outputType: Output.Type
    
    init(
        host: String,
        path: String,
        method: HTTPMethod,
        input: Input,
        outputType: Output.Type
    ) {
        self.host = host
        self.path = path
        self.method = method
        self.input = input
        self.outputType = outputType
    }
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = path.hasPrefix("/") ? path : "/" + path
        return components.url
    }
}

