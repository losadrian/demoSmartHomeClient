import Foundation

typealias RemoveDevicesFromSmartHomeUseCaseFactory = (
    RemoveDevicesFromSmartHomeUseCase.RequestValue, @escaping (RemoveDevicesFromSmartHomeUseCase.ResultValue) -> Void
) -> UseCase

final class RemoveDevicesFromSmartHomeUseCase: UseCase {
    // MARK: - RequestValue
    struct RequestValue {
        let smartHome: SmartHome
        let devicesToRemove: Set<SmartDevice>
    }
    // MARK: - ResultValue
    typealias ResultValue = (Result<Bool, Error>)
    
    // MARK: - Private properties
    private let requestValue: RequestValue
    private let completion: (ResultValue) -> Void
    private let smartDeviceRepository: SmartDeviceRepository
    
    // MARK: - Initializers
    init(requestValue: RequestValue,
         completion: @escaping (ResultValue) -> Void,
         smartDeviceRepository: SmartDeviceRepository) {
        
        self.requestValue = requestValue
        self.completion = completion
        self.smartDeviceRepository = smartDeviceRepository
    }
    
    // MARK: - Executor
    public func execute() {
        for deviceToRemove in requestValue.devicesToRemove {
            smartDeviceRepository.removeDevice(bySmartHomeId: requestValue.smartHome.homeID, andByDeviceId: deviceToRemove.deviceID) { result in
                switch result {
                case .success(let success):
                    self.completion(.success(success))
                case .failure(let error):
                    self.completion(.failure(error))
                }
            }
        }
    }
}
