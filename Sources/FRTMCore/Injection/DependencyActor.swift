//
//  DependencyContainer.swift
//  FRTMCore
//
//  Created by PALOMBA VALENTINO on 19/08/25.
//

import Foundation

public protocol DependencyContainer {
    func register<T>(_ dependencyProvider: any DependencyProvider<T>)
    func resolve<T>(_ type: T.Type) -> T?
    func resolve<T>(_ type: T.Type) throws -> T
}

public final class CoreDependencyContainer: DependencyContainer {
    private var factories: [ServiceKey: () -> Any] = [:]
    private var singletons: [ServiceKey: Any] = [:]
    
    private init() {}
    
    nonisolated(unsafe) public static let shared = CoreDependencyContainer()
    
    public func register<T>(_ dependencyProvider: any DependencyProvider<T>) {
        let key = ServiceKey(type: dependencyProvider.serviceType)
        
        switch dependencyProvider.lifeCycle {
        case .singleton:
            let instance = dependencyProvider.createInstance()
            singletons[key] = instance
            
        case .factory:
            factories[key] = {
                dependencyProvider.createInstance()
            }
        }
    }
    
    public func resolve<T: Sendable>(_ type: T.Type) -> T? {
        let key = ServiceKey(type: type)
        
        // Check singletons first
        if let singleton = singletons[key] as? T {
            return singleton
        }
        
        // Then check factories
        if let factory = factories[key] {
            return factory() as? T
        }
        
        return nil
    }
    
    public func resolve<T: Sendable>(_ type: T.Type) throws -> T {
        guard let instance: T = resolve(type) else {
            throw DependencyError.serviceNotRegistered(String(describing: type))
        }
        return instance
    }
    
    public func removeAll() async {
        factories.removeAll()
        singletons.removeAll()
    }
    
    public func remove<T>(_ type: T.Type) async {
        let key = ServiceKey(type: type)
        factories.removeValue(forKey: key)
        singletons.removeValue(forKey: key)
    }
}


extension CoreDependencyContainer {
    
    /// Register a singleton instance
    public func registerSingleton<T>(_ type: T.Type, factory: @Sendable @escaping () -> T) {
        let provider = ServiceProvider(type, lifeCycle: .singleton, factory: factory)
        register(provider)
    }
    
    /// Register a factory
    public func registerFactory<T>(_ type: T.Type, factory: @Sendable @escaping () -> T) {
        let provider = ServiceProvider(type, lifeCycle: .factory, factory: factory)
        register(provider)
    }
    
    /// Register an existing instance as singleton
    public func registerInstance<T: Sendable>(_ type: T.Type, instance: T) {
        let provider = ServiceProvider(type, lifeCycle: .singleton) { instance }
        register(provider)
    }
}
