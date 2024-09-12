//
//  File.swift
//  
//
//  Created by Fandrian Rhamadiansyah on 12/09/24.
//

import Foundation
import CoreData

enum StorageType {
  case persistent, inMemory
}

class CoreDataManager {
    static let shared = CoreDataManager()
    
    let container: NSPersistentContainer
    
    let context: NSManagedObjectContext
    
    init(storageType: StorageType = .persistent) {
        if let modelURL = Bundle.module.url(forResource:"CoreDataSPM", withExtension: "momd"), let model = NSManagedObjectModel(contentsOf: modelURL) {
            
            container = NSPersistentContainer(name: "CoreDataSPM", managedObjectModel: model)
            
            if storageType == .inMemory {
                //for testing
                let description = NSPersistentStoreDescription()
                description.url = URL(fileURLWithPath: "/dev/null")
                container.persistentStoreDescriptions = [description]
            }
            
            container.loadPersistentStores { description, error in
                if let error = error {
                    print("Error loading core data: \(error)")
                }
            }
            
            if storageType == .inMemory {
                context = container.newBackgroundContext()
            } else {
                context = container.viewContext
            }
            
        } else {
            fatalError("fail to init NSPersistentContainer, bundle not found")
        }
    }
    
    func save() async throws {
        if context.hasChanges {
            try await context.perform {
                try self.context.save()
            }
        }
    }
    
    func delete(_ object: NSManagedObject) {
        context.delete(object)
    }
    
}
