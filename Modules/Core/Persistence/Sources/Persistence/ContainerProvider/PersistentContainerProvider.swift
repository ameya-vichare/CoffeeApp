//
//  PersistentContainerProvider.swift
//  Persistence
//
//  Created by Ameya on 04/11/25.
//

import CoreData

public final class PersistentContainerProvider {
    public let container: NSPersistentContainer

    public init(
        modelName: String = "AppModel",
        storeURL: URL? = nil,
        inMemory: Bool = false
    ) {
        guard let modelURL = Bundle.module.url(forResource: modelName, withExtension: "momd"),
              let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)
        else {
            fatalError("Failed to load model \(modelName) from Bundle.module")
        }
        
        //Transformers
        ValueTransformer
            .setValueTransformer(
                IntArrayTransformer(),
                forName: NSValueTransformerName("IntArrayTransformer")
            )
        
        container = NSPersistentContainer(name: modelName, managedObjectModel: managedObjectModel)
        if inMemory {
            let desc = NSPersistentStoreDescription()
            desc.type = NSInMemoryStoreType
            container.persistentStoreDescriptions = [desc]
        } else if let url = storeURL {
            let desc = NSPersistentStoreDescription(url: url)
            container.persistentStoreDescriptions = [desc]
        }
        container.loadPersistentStores { storeDesc, error in
            if let error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergePolicy(
            merge: .mergeByPropertyObjectTrumpMergePolicyType
        )
    }
}
