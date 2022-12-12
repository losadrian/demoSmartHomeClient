import Foundation
import CoreData

extension SmartDeviceEntity {
    convenience init(fromDomain smartDevice: SmartDevice, insertInto context: NSManagedObjectContext) {
        self.init(context: context)
        communication = smartDevice.communication
        deviceID = Int16(smartDevice.deviceID)
        manufacturer = smartDevice.manufacturer
        productName = smartDevice.productName
    }
    
    func toDomain() -> SmartDevice {
        let communicationToDomain = communication ?? ""
        let deviceIDToDomain = Int(deviceID)
        let manufacturerToDomain = manufacturer ?? ""
        let productNameToDomain = productName ?? ""
        
        return SmartDevice(communication: communicationToDomain, deviceID: deviceIDToDomain, manufacturer: manufacturerToDomain, productName: productNameToDomain)
    }
}
