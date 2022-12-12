import Foundation

typealias FetchDevicesOfSmartHomeUseCaseFactory = (
    FetchDevicesOfSmartHomeUseCase.RequestValue, @escaping (FetchDevicesOfSmartHomeUseCase.ResultValue) -> Void
) -> UseCase

final class FetchDevicesOfSmartHomeUseCase: UseCase {
    // MARK: - RequestValue
    struct RequestValue {
        let smartHome: SmartHome
    }
    // MARK: - ResultValue
    typealias ResultValue = (Result<[SmartDevice], Error>)
    
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
        smartDeviceRepository.getDevices(bySmartHomeId: requestValue.smartHome.homeID, completion: { smartDevicesResult in
            switch smartDevicesResult {
            case .success(let smartDeviceListArray):
                self.completion(.success(smartDeviceListArray))
            case .failure(let error):
                self.completion(.failure(error))
            }
        })
    }
}
