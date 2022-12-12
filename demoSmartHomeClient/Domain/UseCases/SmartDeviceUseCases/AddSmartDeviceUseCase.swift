import Foundation

typealias AddSmartDeviceUseCaseFactory = (
    AddSmartDeviceUseCase.RequestValue, @escaping (AddSmartDeviceUseCase.ResultValue) -> Void
) -> UseCase

final class AddSmartDeviceUseCase: UseCase {
    // MARK: - RequestValue
    struct RequestValue {
        let smartDevice: SmartDevice
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
        let communication = requestValue.smartDevice.communication
        let manufacturer = requestValue.smartDevice.manufacturer
        let productName = requestValue.smartDevice.productName
        
        if communication.isEmpty || manufacturer.isEmpty || productName.isEmpty {
            self.completion(.failure(ApplicationError.allDevicePropertyFieldHasToBeFilled))
            return
        }
        
        smartDeviceRepository.addDevice(smartDevice: requestValue.smartDevice) { result in
            switch result {
            case .success(let success):
                self.completion(.success(success))
            case .failure(let error):
                self.completion(.failure(error))
            }
        }
    }
}
