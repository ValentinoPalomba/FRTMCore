//
//  DependencyError.swift
//  FRTMCore
//
//  Created by PALOMBA VALENTINO on 19/08/25.
//

import Foundation


public enum DependencyError: Error, LocalizedError {
    case serviceNotRegistered(String)
    case circularDependency(String)
    
    public var errorDescription: String? {
        switch self {
        case .serviceNotRegistered(let service):
            return "Service '\(service)' is not registered in the container"
        case .circularDependency(let service):
            return "Circular dependency detected for service '\(service)'"
        }
    }
}
