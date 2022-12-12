import Foundation
import Combine

final class MockAPIClient: APIClientType {
    
    var smartHomesWithDeviceIDs = [SmartHome(homeID: 1, homeName: "BLUE House") : [1,3,6,2], SmartHome(homeID: 2, homeName: "RED House") : [4,6,5]]
    
    var smartDevices : [SmartDevice] = [
        SmartDevice(communication: "Zigbee", deviceID: 1, manufacturer: "Eufy", productName: "Indoor Cam 2K Pan & Tilt P24"),
        SmartDevice(communication: "WiFi", deviceID: 2, manufacturer: "Shelly", productName: "Door Window 2"),
        SmartDevice(communication: "Zigbee", deviceID: 3, manufacturer: "Aqara", productName: "Door and Window Sensor"),
        SmartDevice(communication: "Z-Wave", deviceID: 4, manufacturer: "Fibaro", productName: "Relay Switch FGS-223"),
        SmartDevice(communication: "WiFi", deviceID: 5, manufacturer: "Shelly", productName: "RGBW2 RGBW Led controller"),
        SmartDevice(communication: "WiFi", deviceID: 6, manufacturer: "Wemo", productName: "Smart Plug")
    ]
    
    func cancel() {}
}

// MARK: - SmartHomeRepository
extension MockAPIClient: SmartHomeRepository {
    func getCredentials(byPassword password: String, completion: @escaping (Result<SmartHomeAuthCredential, Error>) -> Void) {
        if password.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            completion(.failure(APIError.apiError(reason: ErrorResponseModel(errorCode: -6, errorMessage: "Password is required to authenticate the user."))))
            return
        }
        if password == "welcome" {
            completion(.success(SmartHomeAuthCredential(accessToken: "5E4D3C2B1A")))
        }
        else {
            completion(.failure(APIError.apiError(reason: ErrorResponseModel(errorCode: -7, errorMessage: "Invalid password."))))
        }
    }
    
    func getSmarthomes(completion: @escaping (Result<SmartHomeListResponseModel, Error>) -> Void) {
        completion(.success(smartHomesWithDeviceIDs.keys.map({$0})))
    }
}

// MARK: - SmartDeviceRepository
extension MockAPIClient: SmartDeviceRepository {
    func getDevices(completion: @escaping (Result<DeviceListResponseModel, Error>) -> Void) {
        completion(.success(smartDevices))
    }
    
    func getDevices(bySmartHomeId homeID: Int, completion: @escaping (Result<DeviceListResponseModel, Error>) -> Void) {
        var mockAuthFailed = false
        
        if let accessToken = KeychainRepository.shared.getAccessToken() {
            if accessToken != "5E4D3C2B1A" {
                mockAuthFailed = true
            }
        }
        else {
            mockAuthFailed = true
        }
        if mockAuthFailed {
            completion(.failure(APIError.unauthenticated))
            return
        }
        
        var resultSmartDevices : [SmartDevice] = []
        let smarthomes : [SmartHome] = smartHomesWithDeviceIDs.keys.map({$0})
        let smarthome : SmartHome? = smarthomes.filter { $0.homeID == homeID }.first
        if let smarthome = smarthome {
            let deviceIDs : [Int] = smartHomesWithDeviceIDs[smarthome] ?? []
            let selectSet = Set(deviceIDs)
            resultSmartDevices = smartDevices.filter { selectSet.contains($0.deviceID) }
        }
        
        completion(.success(resultSmartDevices))
    }
    
    func addDevice(smartDevice: SmartDevice, completion: @escaping (Result<Bool, Error>) -> Void) {
        if let lastDeviceID = smartDevices.sorted(by: { $0.deviceID > $1.deviceID }).first?.deviceID {
            let newSmartDevice = SmartDevice(communication: smartDevice.communication, deviceID: lastDeviceID+1, manufacturer: smartDevice.manufacturer, productName: smartDevice.productName)
            smartDevices.append(newSmartDevice)
            completion(.success(true))
        }
        else {
            completion(.success(false))
        }
    }
    
    func removeDevice(byDeviceId deviceID: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        smartDevices = smartDevices.filter {$0.deviceID != deviceID}
        completion(.success(true))
    }
    
    func removeDevice(bySmartHomeId homeID: Int, andByDeviceId deviceID: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        let smarthomes : [SmartHome] = smartHomesWithDeviceIDs.keys.map({$0})
        let smarthome : SmartHome? = smarthomes.filter { $0.homeID == homeID }.first
        if let smarthome = smarthome {
            let deviceIDs : [Int] = smartHomesWithDeviceIDs[smarthome] ?? []
            let filteredDeviceIDs = deviceIDs.filter {$0 != deviceID}
            smartHomesWithDeviceIDs[smarthome] = filteredDeviceIDs
        }
    }
    
    func searchDevices(byCommunication communication: String?, byManufacturer manufacturer: String?, byProductName productName: String?, completion: @escaping (Result<[SmartDevice], Error>) -> Void) {
        var filteredSmartDevices: [SmartDevice] = []
        if let communicationToQuery = communication {
            
            filteredSmartDevices = smartDevices.filter {$0.communication == communicationToQuery}
        }
        if let manufacturerToQuery = manufacturer {
            filteredSmartDevices = smartDevices.filter {$0.manufacturer == manufacturerToQuery}
        }
        if let productNameToQery = productName {
            filteredSmartDevices = smartDevices.filter {$0.productName == productNameToQery}
        }
        completion(.success(filteredSmartDevices))
    }
}


