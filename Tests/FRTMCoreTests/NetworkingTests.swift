import Testing
@testable import FRTMCore
import Foundation

// MARK: - Mocks

struct MockUser: Codable, Equatable, Sendable {
    let id: Int
    let name: String
}

struct MockEmptyBody: Codable, Sendable {}

struct MockGetUserApi: ApiCatalog {
    typealias Input = MockEmptyBody
    typealias Output = MockUser
    var host: String { "test.com" }
    var path: String { "/user" }
    var method: HTTPMethod { .get }
    var headers: [String : String]? { nil }
}

// MARK: - Tests

@Test func testSuccessfulRequest() async throws {
    let user = MockUser(id: 1, name: "Test User")
    let userData = try JSONEncoder().encode(user)
    
    let session = URLSession.mock(response: .success(userData))
    
    let networkManager = CoreNetworkManager(session: session)
    let api = MockGetUserApi()
    let request = api.request(input: MockEmptyBody())

    let result = try await networkManager.call(request)
    #expect(result == user)
}

@Test func testNotFoundError() async throws {
    let session = URLSession.mock(response: .failure(APIError.statusCode(404)))
    
    let networkManager = CoreNetworkManager(session: session)
    let api = MockGetUserApi()
    let request = api.request(input: MockEmptyBody())

    await #expect(throws: APIError.self) {
        _ = try await networkManager.call(request)
    }
}

// MARK: - Helper

extension URLSession {
    static func mock(response: Result<Data, Error>) -> URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        MockURLProtocol.response = response
        return URLSession(configuration: configuration)
    }
}

class MockURLProtocol: URLProtocol, @unchecked Sendable {
    nonisolated(unsafe) static var response: Result<Data, Error>?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        if let response = MockURLProtocol.response {
            switch response {
            case .success(let data):
                let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                client?.urlProtocol(self, didLoad: data)
            case .failure(let error):
                client?.urlProtocol(self, didFailWithError: error)
            }
        }
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}