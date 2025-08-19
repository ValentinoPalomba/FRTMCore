//
//  SingleDependency.swift
//  FRTMCore
//
//  Created by PALOMBA VALENTINO on 19/08/25.
//

import Foundation

public enum DependencyLifeCycle : Sendable{
    case singleton
    case factory
}

public protocol DependencyProvider<T>: Sendable {
    associatedtype T
    var lifeCycle: DependencyLifeCycle { get set }
    var serviceType: T.Type { get }
    func createInstance() -> T
}

extension DependencyProvider {
    func setLifeCycle(_ lifeCycle: DependencyLifeCycle) -> Self {
        var copy = self
        copy.lifeCycle = lifeCycle
        return copy
    }
}

public struct ServiceProvider<T>: DependencyProvider {
    public var lifeCycle: DependencyLifeCycle
    public let serviceType: T.Type
    private let factory: @Sendable () -> T
    
    public init(
        _ serviceType: T.Type,
        lifeCycle: DependencyLifeCycle = .factory,
        factory: @Sendable @escaping () -> T
    ) {
        self.serviceType = serviceType
        self.lifeCycle = lifeCycle
        self.factory = factory
    }
    
    public func createInstance() -> T {
        return factory()
    }
}
