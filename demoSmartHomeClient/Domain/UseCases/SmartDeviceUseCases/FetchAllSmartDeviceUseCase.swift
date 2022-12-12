import Foundation

typealias FetchAllSmartDeviceUseCaseFactory = (
    @escaping (FetchAllSmartDeviceUseCase.ResultValue) -> Void
) -> UseCase

final class FetchAllSmartDeviceUseCase: UseCase {
    // MARK: - ResultValue
    typealias ResultValue = (Result<[SmartDevice], Error>)
    
    // MARK: - Private properties
    private let completion: (ResultValue) -> Void
    private let smartDeviceRepository: SmartDeviceRepository
    private let persistentRepository: PersistentRepository
    
    // MARK: - Initializers
    public init(completion: @escaping (ResultValue) -> Void,
                smartDeviceRepository: SmartDeviceRepository,
                persistentRepository: PersistentRepository) {
        self.completion = completion
        self.smartDeviceRepository = smartDeviceRepository
        self.persistentRepository = persistentRepository
    }
    
    // MARK: - Executor
    public func execute() {
        smartDeviceRepository.getDevices(completion: { smartDevicesResult in
            switch smartDevicesResult {
            case .success(let smartDeviceListArray):
                self.persistentRepository.syncDevices(devices: smartDeviceListArray) { _ in }
                self.completion(.success(smartDeviceListArray))
            case .failure(let error):
                self.completion(.failure(error))
                self.persistentRepository.getDevices { smartHomesFromPresistenceResult in
                    switch smartHomesFromPresistenceResult {
                    case .success(let smartHomeListArray):
                        self.completion(.success(smartHomeListArray))
                    case .failure(_):
                        self.completion(.failure(error))
                    }
                }
            }
        })
    }
}
