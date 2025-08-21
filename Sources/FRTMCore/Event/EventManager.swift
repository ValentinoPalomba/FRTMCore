//
//  EventManager.swift
//  FRTMCore
//
//  Created by PALOMBA VALENTINO on 21/08/25.
//

import Foundation

public protocol EventManager {
    /// Registers a RefreshHandler with a given name as a weak reference
    /// - Parameters:
    ///   - refreshHandler: the RefreshHandler to register
    ///   - name: a unique name used to register and store a reference for the refresh handler
    func register(_ eventHandler: EventHandler, for name: String)
    
    /// Asks to its handlers to handle the specified RefreshEvent
    /// - Parameter event: The RefreshEvent to deliver to all refresh handlers
    func refresh(for event: Event)
    
    /// Unregisters a refresh handler with the given name
    /// - Parameters:
    ///   - refreshHandler: The handler conforming to `RefreshHandler` to be removed
    ///   - name: The name associated with the handler
    func unsubscribe(_ refreshHandler: EventHandler, for name: String)
}

/// The Core container for all the RefreshHandler
public final class CoreEventManager: EventManager {
    
    fileprivate final class WeakEventHandler {
        weak var value: (any EventHandler)?
        
        init(value: any EventHandler) {
            self.value = value
        }
    }
        
    private static let loggerCategory: String = "CoreRefreshManager"
    
    /// An array containing all the registered refresh handlers with weak references
    private var weakEventHandlers: [String: WeakEventHandler] = [:]
    
    /// Creates a new instance of the RefreshManager
    public init() { }
    
    /// Registers a refresh handler with a given name as a weak reference
    /// - Parameters:
    ///   - refreshHandler: The handler conforming to `RefreshHandler`
    ///   - name: The name to associate with the handler
    public func register(_ eventHandler: EventHandler, for name: String) {
        guard weakEventHandlers[name]?.value == nil else {
            return
        }
        weakEventHandlers[name] = WeakEventHandler(value: eventHandler)
    }
    
    /// Triggers the refresh event for all registered handlers
    /// - Parameter event: The event to refresh with
    public func refresh(for event: Event) {
        // Handle weak references and remove any nil references
        for (name, weakHandler) in weakEventHandlers {
            if let handler = weakHandler.value {
                handler.handle(event)
            } else {
                weakEventHandlers.removeValue(forKey: name)
            }
        }
    }
    
    /// Unregisters a refresh handler with the given name
    /// - Parameters:
    ///   - refreshHandler: The handler conforming to `RefreshHandler` to be removed
    ///   - name: The name associated with the handler
    public func unsubscribe(_ eventHandler: EventHandler, for name: String) {
       if let weakHandler = weakEventHandlers[name], weakHandler.value === eventHandler {
            weakEventHandlers.removeValue(forKey: name)
        }
    }
}

