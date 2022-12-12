import Foundation

typealias SearchSmartDevicesUseCaseFactory = (
    SearchSmartDevicesUseCase.RequestValue, @escaping (SearchSmartDevicesUseCase.ResultValue) -> Void
) -> UseCase

typealias SmartDeviceQuery = (communication: String, manufacturer: String, productName: String)

final class SearchSmartDevicesUseCase: UseCase {
    // MARK: - RequestValue
    struct RequestValue {
        let smartDeviceQuery: SmartDeviceQuery
    }
    // MARK: - ResultValue
    typealias ResultValue = (Result<[SmartDevice], Error>)
    
    // MARK: - Private properties
    private let requestValue: RequestValue
    private let completion: (ResultValue) -> Void
    private let smartDeviceRepository: SmartDeviceRepository
    
    // MARK: - Initializers
    public init(requestValue: RequestValue,
                completion: @escaping (ResultValue) -> Void,
                smartDeviceRepository: SmartDeviceRepository) {
        self.requestValue = requestValue
        self.completion = completion
        self.smartDeviceRepository = smartDeviceRepository
    }
    
    // MARK: - Executor
    public func execute() {
        let communicationToQuery : String? = check(stringToQuery: requestValue.smartDeviceQuery.communication)
        let manufacturerToQuery : String? = check(stringToQuery: requestValue.smartDeviceQuery.manufacturer)
        let productNameToQuery : String? = check(stringToQuery: requestValue.smartDeviceQuery.productName)
        
        if noFieldsHaveBeenFilled(communicationToQuery, manufacturerToQuery, productNameToQuery) {
            self.completion(.failure(ApplicationError.aPropertyFieldHasToBeFilledToSearchDevices))
            return
        }
        
        smartDeviceRepository.searchDevices(byCommunication: communicationToQuery, byManufacturer: manufacturerToQuery, byProductName: productNameToQuery) { smartDevicesResult in
            switch smartDevicesResult {
            case .success(let smartDeviceListArray):
                self.completion(.success(smartDeviceListArray))
            case .failure(let error):
                self.completion(.failure(error))
            }
        }
    }
    
    private func check(stringToQuery: String) -> String? {
        return stringToQuery.isEmpty ? nil : stringToQuery
    }
    
    private func noFieldsHaveBeenFilled(_ communicationToQuery : String?, _ manufacturerToQuery : String?, _ productNameToQuery : String?) -> Bool {
        var isOneFieldHasBeenFilled = false
        if let _ = communicationToQuery {
            isOneFieldHasBeenFilled = true
        }
        if let _ = manufacturerToQuery {
            isOneFieldHasBeenFilled = true
        }
        if let _ = productNameToQuery {
            isOneFieldHasBeenFilled = true
        }
        return !isOneFieldHasBeenFilled
    }
}
