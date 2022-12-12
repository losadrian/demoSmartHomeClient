import Foundation
import CoreData

final class CoreDataQueriesStorage {
    // MARK: - Private properties
    private let coreDataStack: CoreDataStack
    
    // MARK: - Initializers
    init(coreDataStack: CoreDataStack = CoreDataStack()) {
        self.coreDataStack = coreDataStack
    }
}

// MARK: - LocalPersistentRepository
extension CoreDataQueriesStorage: PersistentRepository {
    func getDevices(completion: @escaping (Result<[SmartDevice], Error>) -> Void) {
        do {
            let result = try self.getAllDevicesFromCoreData(inContext: coreDataStack.mainContext)
            completion(.success(result.compactMap { $0.toDomain() }))
        } catch {
            completion(.failure(ApplicationError.defaultErrorWithFailureReason(reason: "Could not find any smart device data.")))
        }
    }
    
    func syncDevices(devices: [SmartDevice], completion: @escaping (Result<Void, Error>) -> Void) {
        let context = coreDataStack.mainContext
        do {
            try self.removeAllDevicesFromCoreData(inContext: coreDataStack.mainContext)
            for smartDevice in devices {
                let _ = SmartDeviceEntity(fromDomain: smartDevice, insertInto: context)
            }
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
}

// MARK: - Private
extension CoreDataQueriesStorage {
    private func removeAllDevicesFromCoreData(inContext context: NSManagedObjectContext) throws {
        do {
            let smartDeviceEntities = try self.getAllDevicesFromCoreData(inContext: coreDataStack.mainContext)
            for smartDeviceEntity in smartDeviceEntities {
                context.delete(smartDeviceEntity)
            }
        } catch {
            throw error
        }
    }
    
    private func getAllDevicesFromCoreData(inContext context: NSManagedObjectContext) throws -> [SmartDeviceEntity] {
        do {
            let stationRequest: NSFetchRequest<SmartDeviceEntity> = SmartDeviceEntity.fetchRequest()
            
            let sectionSortDescriptor = NSSortDescriptor(key: "deviceID", ascending: true)
            let sortDescriptors = [sectionSortDescriptor]
            stationRequest.sortDescriptors = sortDescriptors
            
            let result = try context.fetch(stationRequest)
            if result.isEmpty {
                return []
            }
            else {
                return result
            }
        }
        catch {
            throw error
        }
    }
}
