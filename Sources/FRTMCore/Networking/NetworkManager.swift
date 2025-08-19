
//
//  APIClient.swift
//
//
//  Created by Gemini on 19/08/25.
//

import Foundation

public protocol NetworkManager: Sendable {
    func call<Input, Output>(_ dataRequest: DataRequest<Input, Output>) async throws -> Output
}

public actor CoreNetworkManager: NetworkManager {
    
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
    init(session: URLSession = .shared) {
        self.session = session
        self.decoder = JSONDecoder()
        self.encoder = JSONEncoder()
    }
    
    public func call<Input, Output: Sendable>(_ dataRequest: DataRequest<Input, Output>) async throws -> Output where Input : Sendable {
        guard let url = dataRequest.url else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = dataRequest.method.rawValue
        
        
        if let headers = dataRequest.headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        // Aggiungi body per metodi che lo supportano
        if dataRequest.method != .get {
            do {
                request.httpBody = try encoder.encode(dataRequest.input)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                throw APIError.decodingFailed(error)
            }
        }
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.statusCode(httpResponse.statusCode)
        }
        
        do {
            let decodedData = try decoder.decode(
                dataRequest.outputType,
                from: data
            )
            return decodedData
        } catch {
            throw APIError.decodingFailed(error)
        }
    }
    
    
}
