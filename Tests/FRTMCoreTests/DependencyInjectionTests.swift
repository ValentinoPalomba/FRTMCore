
import Testing
@testable import FRTMCore

protocol MyServiceProtocol: Sendable {}
final class MyService: MyServiceProtocol {}

@Test func testRegisterAndResolveSingleton() async throws {
    let container = CoreDependencyContainer.shared
    await container.registerSingleton(MyServiceProtocol.self) { MyService() }
    
    let service: MyServiceProtocol = try container.resolve(
        MyServiceProtocol.self
    )
    #expect(service is MyService)
}

@Test func testRegisterAndResolveFactory() async throws {
    let container = CoreDependencyContainer.shared
    await container.registerFactory(MyServiceProtocol.self) { MyService() }
    
    let service: MyServiceProtocol = try container.resolve(
        MyServiceProtocol.self
    )
    #expect(service is MyService)
}

@Test func testRegisterAndResolveInstance() async throws {
    let container = CoreDependencyContainer.shared
    let instance = MyService()
    await container.registerInstance(MyServiceProtocol.self, instance: instance)
    
    let service: MyServiceProtocol = try container.resolve(
        MyServiceProtocol.self
    )
    #expect(service as? MyService === instance)
}

@Test func testResolveUnregisteredService() async throws {
    let container = CoreDependencyContainer.shared
    await container.removeAll()
    
    #expect(throws: DependencyError.self) {
        let _: MyServiceProtocol = try container.resolve(MyServiceProtocol.self)
    }
}
