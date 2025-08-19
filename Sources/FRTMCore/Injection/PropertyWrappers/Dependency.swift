//
//  File.swift
//  FRTMCore
//
//  Created by PALOMBA VALENTINO on 19/08/25.
//

import Foundation

@propertyWrapper
public struct Dependency<T: Sendable> {
    private var container: CoreDependencyContainer = .shared
    
    public init(container: CoreDependencyContainer) {
        self.container = container
    }
    
    public init() {
        
    }
    
    public var wrappedValue: T {
        get {
            do {
                return try container.resolve(T.self)
            } catch {
                fatalError("No value fund for type \(T.self)")
            }
        }
    }
}

@propertyWrapper
public struct SafeDependency<T: Sendable> {
    
    private var container: CoreDependencyContainer = .shared
    
    public init(container: CoreDependencyContainer) {
        self.container = container
    }
    
    public init() {
        
    }
    
    public var wrappedValue: T? {
        get {
            return container.resolve(T.self)
        }
    }
}
