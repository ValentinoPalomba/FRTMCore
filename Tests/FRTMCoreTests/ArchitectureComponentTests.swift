
import Testing
@testable import FRTMCore

// MARK: - UseCase Tests

protocol MockUseCaseProtocol: UseCase, Sendable where Input == String, Output == String {}

final class MockUseCase: MockUseCaseProtocol {
    func execute(_ input: String) throws -> String {
        return "Hello, \(input)!"
    }
}

@Test func testUseCaseExecution() throws {
    let useCase = MockUseCase()
    let result = try useCase.execute("World")
    #expect(result == "Hello, World!")
}
