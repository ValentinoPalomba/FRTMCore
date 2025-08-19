//
//  UseCase.swift
//  FRTMCore
//
//  Created by PALOMBA VALENTINO on 19/08/25.
//

import Foundation

public protocol UseCase<Input, Output>: Sendable {
    associatedtype Input
    associatedtype Output
    
    func execute(_ input: Input) throws -> Output
}

extension UseCase where Input == Void {
    func execute() throws -> Output {
        try execute(())
    }
}
