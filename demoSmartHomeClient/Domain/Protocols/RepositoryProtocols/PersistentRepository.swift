protocol PersistentRepository {
    func getDevices(completion: @escaping (Result<[SmartDevice], Error>) -> Void)
    func syncDevices(devices: [SmartDevice], completion: @escaping (Result<Void, Error>) -> Void)
}
