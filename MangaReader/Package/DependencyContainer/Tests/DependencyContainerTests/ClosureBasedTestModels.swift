//
//  ClosureBasedTestModels.swift
//
//
//  Created by Fandrian Rhamadiansyah on 26/08/24.
//

import Foundation

protocol ClosureBasedProtocol {
    func sampleMethod()
}

struct ClosureBasedImplementation: ClosureBasedProtocol {
    func sampleMethod() {
        
    }

}

protocol AnotherDependencyProtocol {
    func anotherSampleMethod()
}

struct AnotherDependencyImplementation: AnotherDependencyProtocol {
    private let service: ClosureBasedProtocol
    
    init(service: ClosureBasedProtocol) {
        self.service = service
    }
    
    func anotherSampleMethod() {
        
    }

}
