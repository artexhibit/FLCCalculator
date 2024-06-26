import CoreData

struct Persistence {
    static let shared = Persistence()
    let databaseName = "FLCCalculator.sqlite"
    
    var oldStoreURL: URL {
        let directory = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
        guard let directory = directory else { fatalError(FLCError.unableToFindAppDirectory.rawValue) }
        return directory.appendingPathComponent(databaseName)
    }
    
    var sharedStoreURL: URL {
        let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.ru.igorcodes.FLCCalculator")
        guard let container = container else { fatalError(FLCError.unableToFindContainerURL.rawValue) }
        return container.appendingPathComponent(databaseName)
    }
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "FLCCalculator")
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        } else if !FileManager.default.fileExists(atPath: oldStoreURL.path) {
           container.persistentStoreDescriptions.first!.url = sharedStoreURL
        }
        //print("Container URL equals: \(container.persistentStoreDescriptions.first!.url!)")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        migrateStore(for: container)
        container.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func migrateStore(for container: NSPersistentContainer) {
        let coordinator = container.persistentStoreCoordinator
        let options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
        guard let oldStore = coordinator.persistentStore(for: oldStoreURL) else { return }
        
        do {
            try coordinator.migratePersistentStore(oldStore, to: sharedStoreURL, options: options, withType: NSSQLiteStoreType)
        } catch {
            print("Unable to migrate to shared store with error: \(error.localizedDescription)")
        }
        removeOldStore()
    }
    
    func removeOldStore() {
        do {
            try FileManager.default.removeItem(at: oldStoreURL)
        } catch {
            print("Unable to delete old store")
        }
    }
    
    func saveContext () {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
