//
//  PersistenceContainer.swift
//  TextToSpeech
//
//  Created by Daniel James Tronca on 01/06/22.
//

import Foundation
import CoreData

class PersistenceContainer {
    
    public static let shared: PersistenceContainer = PersistenceContainer()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Error: \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func saveContext() {
        guard container.viewContext.hasChanges else { return }
        do {
            try container.viewContext.save()
        } catch {
            print("Unresolved error: \(error)")
        }
    }
}
