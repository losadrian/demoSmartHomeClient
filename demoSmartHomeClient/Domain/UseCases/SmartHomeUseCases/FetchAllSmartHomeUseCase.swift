import Foundation

typealias FetchAllSmartHomeUseCaseFactory = (
    @escaping (FetchAllSmartHomeUseCase.ResultValue) -> Void
    ) -> UseCase

final class FetchAllSmartHomeUseCase: UseCase {
    // MARK: - ResultValue
    typealias ResultValue = (Result<[SmartHome], Error>)
    
    // MARK: - Private properties
    private let completion: (ResultValue) -> Void
    private let smartHomeRepository: SmartHomeRepository
    
    // MARK: - Initializers
    public init(completion: @escaping (ResultValue) -> Void,
                smartHomeRepository: SmartHomeRepository) {
        self.completion = completion
        self.smartHomeRepository = smartHomeRepository
    }
    
    // MARK: - Executor
    public func execute() {
        smartHomeRepository.getSmarthomes(completion: { smartHomesResult in
            switch smartHomesResult {
            case .success(let smartHomeListArray):
                self.completion(.success(smartHomeListArray))
            case .failure(let error):
                self.completion(.failure(error))
            }
        })
    }
}
