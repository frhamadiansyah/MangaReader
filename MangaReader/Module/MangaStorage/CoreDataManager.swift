//
//  CoreDataManager.swift
//  MangaReader
//
//  Created by Fandrian Rhamadiansyah on 09/09/24.
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
        container = NSPersistentContainer(name: "Model")
        
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


