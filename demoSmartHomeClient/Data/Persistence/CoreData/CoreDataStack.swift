import Foundation
import CoreData

final class CoreDataStack {
    
    let persistentStoreContainer: NSPersistentContainer
    
    init() {
        persistentStoreContainer = NSPersistentContainer(name: "SmartHomeManagerModel")
        persistentStoreContainer.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        persistentStoreContainer.viewContext.automaticallyMergesChangesFromParent = true
        persistentStoreContainer.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        persistentStoreContainer.viewContext.undoManager = nil
        persistentStoreContainer.viewContext.shouldDeleteInaccessibleFaults = true
    }
    
    lazy var mainContext: NSManagedObjectContext = {
        return self.persistentStoreContainer.viewContext
    }()
    
    lazy var privateContext: NSManagedObjectContext = {
        let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateMOC.parent = self.mainContext
        return privateMOC
    }()
    
    lazy var model: NSManagedObjectModel = {
        return self.persistentStoreContainer.managedObjectModel
    }()
    
    // MARK: - Core Data Saving support
    func saveMainContext () {
        if mainContext.hasChanges {
            do {
                try mainContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func saveContexts(_ completion: @escaping (_ r: Result<Void, Error>) -> Void) {
        privateContext.perform {
            do {
                try self.privateContext.save()
                NSLog("✏️: The privateQueueContext saved")
                self.mainContext.performAndWait {
                    if self.mainContext.hasChanges {
                        do {
                            try self.mainContext.save()
                            NSLog("✏️: The mainContext saved")
                            completion(.success(()))
                        } catch let error as NSError {
                            NSLog("🚨: ERROR:: mainContext() throws an Unresolved error \(error), \(error.userInfo)")
                            completion(.failure(error))
                        }
                    } else {
                        completion(.success(()))
                    }
                }
            } catch let error as NSError {
                NSLog("🚨: ERROR:: privateContext() throws an Unresolved error \(error), \(error.userInfo)")
                completion(.failure(error))
            }
        }
    }
}
