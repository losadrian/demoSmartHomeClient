protocol SmartDeviceRepository {
    func getDevices(completion: @escaping (Result<[SmartDevice], Error>) -> Void)
    func getDevices(bySmartHomeId homeID: Int, completion: @escaping (Result<[SmartDevice], Error>) -> Void)
    func addDevice(smartDevice: SmartDevice, completion: @escaping (Result<Bool, Error>) -> Void)
    func removeDevice(byDeviceId deviceID: Int, completion: @escaping (Result<Bool, Error>) -> Void)
    func removeDevice(bySmartHomeId homeID: Int, andByDeviceId deviceID: Int, completion: @escaping (Result<Bool, Error>) -> Void)
    func searchDevices(byCommunication communication: String?, byManufacturer manufacturer: String?, byProductName productName: String?, completion: @escaping (Result<[SmartDevice], Error>) -> Void)
}
