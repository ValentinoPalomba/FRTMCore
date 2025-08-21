//
//  EventHandler.swift
//  FRTMCore
//
//  Created by PALOMBA VALENTINO on 21/08/25.
//

import Foundation
/// A protocol representing a component thaht can handle refresh events
public protocol EventHandler: AnyObject {
    /// The method called when an RefreshEvent should be processed by the component
    func handle(_ event: Event)
}
