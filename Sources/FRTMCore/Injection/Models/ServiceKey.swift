//
//  ServiceKey.swift
//  FRTMCore
//
//  Created by PALOMBA VALENTINO on 09/09/25.
//

import Foundation
struct ServiceKey: Hashable {
    private let typeID: ObjectIdentifier

    init(type: Any.Type) {
        self.typeID = ObjectIdentifier(type)
    }
}

