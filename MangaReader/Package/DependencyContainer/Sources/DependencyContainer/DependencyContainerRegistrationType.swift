//
//  DependencyContainerRegistrationType.swift
//
//
//  Created by Fandrian Rhamadiansyah on 25/08/24.
//

import Foundation

public enum DependencyContainerRegistrationType {
    case singleInstance(AnyObject)
    case closureBased(() -> Any)
}
