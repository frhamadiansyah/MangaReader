//
//  SingleInstanceTestModels.swift
//
//
//  Created by Fandrian Rhamadiansyah on 26/08/24.
//

import Foundation

protocol SingleInstanceProtocol: AnyObject {
    func sampleMethod()
}

final class SingleInstanceImplementation: SingleInstanceProtocol {
    func sampleMethod() {
        
    }
}
