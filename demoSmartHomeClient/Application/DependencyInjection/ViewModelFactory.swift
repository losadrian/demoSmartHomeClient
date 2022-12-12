import Foundation

final class ViewModelFactory: ObservableObject {
    private let apiClient: APIClientType
    private let keychainRepository: KeychainRepository
    private let coreDataQueriesStorage: CoreDataQueriesStorage
    
    init(apiClient: APIClientType = APIClient(),
         keychainRepository: KeychainRepository = KeychainRepository.shared,
         coreDataQueriesStorage: CoreDataQueriesStorage = CoreDataQueriesStorage()) {
        self.apiClient = apiClient
        self.keychainRepository = keychainRepository
        self.coreDataQueriesStorage = coreDataQueriesStorage
    }
    
    // MARK: - SmartHomeListViewModel
    public func getSmartHomeListViewModel() -> SmartHomeListViewModel {
        // MARK: - Data Layer
        let smartHomeRepository: SmartHomeRepository = apiClient
        
        // MARK: - Domain Layer
        func makeFetchAllSmartHomeUseCase(completion: @escaping (FetchAllSmartHomeUseCase.ResultValue) -> Void) -> UseCase {
            return FetchAllSmartHomeUseCase(completion: completion,
                                            smartHomeRepository: smartHomeRepository)
        }
        
        // MARK: - ViewModel
        let viewModel = SmartHomeListViewModel(makeFetchAllSmartHomeUseCase)
        return viewModel
    }
    
    // MARK: - SmartHomeViewModel
    public func getSmartHomeViewModel(smartHome: SmartHome) -> SmartHomeViewModel {
        // MARK: - Data Layer
        let smartDeviceRepository: SmartDeviceRepository = apiClient
        let smartHomeRepository: SmartHomeRepository = apiClient
        let credentialsRepository: CredentialsRepository = keychainRepository
        
        // MARK: - Domain Layer
        func makeFetchDevicesOfSmartHomeUseCase(requestValue:FetchDevicesOfSmartHomeUseCase.RequestValue, completion: @escaping(FetchDevicesOfSmartHomeUseCase.ResultValue) -> Void) -> UseCase {
            return FetchDevicesOfSmartHomeUseCase(requestValue: requestValue,
                                                  completion: completion,
                                                  smartDeviceRepository: smartDeviceRepository)
        }
        
        func makeRemoveDevicesFromSmartHomeUseCase
        (requestValue:RemoveDevicesFromSmartHomeUseCase.RequestValue, completion: @escaping(RemoveDevicesFromSmartHomeUseCase.ResultValue) -> Void) -> UseCase {
            return RemoveDevicesFromSmartHomeUseCase(requestValue: requestValue,
                                                     completion: completion,
                                                     smartDeviceRepository: smartDeviceRepository)
        }
        
        func makeAuthenticateUserUseCase(requestValue:AuthenticateUserUseCase.RequestValue, completion: @escaping(AuthenticateUserUseCase.ResultValue) -> Void) -> UseCase {
            return AuthenticateUserUseCase(requestValue: requestValue,
                                           completion: completion,
                                           credentialsRepository: credentialsRepository,
                                           smartHomeRepository: smartHomeRepository)
        }
        
        func makeDeauthenticateUserUseCase(completion: @escaping(DeauthenticateUserUseCase.ResultValue) -> Void) -> UseCase {
            return DeauthenticateUserUseCase(completion: completion,
                                             credentialsRepository: credentialsRepository)
        }
        
        // MARK: - ViewModel
        let viewModel = SmartHomeViewModel(smartHome: smartHome, makeAuthenticateUserUseCase, makeDeauthenticateUserUseCase, makeFetchDevicesOfSmartHomeUseCase, makeRemoveDevicesFromSmartHomeUseCase)
        return viewModel
    }
    
    // MARK: - SmartDeviceViewModel
    public func getSmartDeviceListViewModel() -> SmartDeviceViewModel {
        // MARK: - Data Layer
        let smartDeviceRepository: SmartDeviceRepository = apiClient
        let persistentRepository: PersistentRepository = coreDataQueriesStorage
        
        // MARK: - Domain Layer
        func makeFetchAllSmartDeviceUseCase(completion: @escaping(FetchAllSmartDeviceUseCase.ResultValue) -> Void) -> UseCase {
            return FetchAllSmartDeviceUseCase(completion: completion,
                                              smartDeviceRepository: smartDeviceRepository,
                                              persistentRepository: persistentRepository)
        }
        
        func makeAddSmartDeviceUseCase(requestValue:AddSmartDeviceUseCase.RequestValue, completion: @escaping (AddSmartDeviceUseCase.ResultValue) -> Void) -> UseCase {
            return AddSmartDeviceUseCase(requestValue: requestValue,
                                         completion: completion,
                                         smartDeviceRepository: smartDeviceRepository)
        }
        
        func makeRemoveSmartDevicesUseCase(requestValue:RemoveSmartDevicesUseCase.RequestValue, completion: @escaping (RemoveSmartDevicesUseCase.ResultValue) -> Void) -> UseCase {
            return RemoveSmartDevicesUseCase(requestValue: requestValue,
                                             completion: completion,
                                             smartDeviceRepository: smartDeviceRepository)
        }
        
        func makeSearchSmartDevicesUseCase(requestValue:SearchSmartDevicesUseCase.RequestValue, completion: @escaping (SearchSmartDevicesUseCase.ResultValue) -> Void) -> UseCase {
            return SearchSmartDevicesUseCase(requestValue: requestValue,
                                             completion: completion,
                                             smartDeviceRepository: smartDeviceRepository)
        }
        
        // MARK: - ViewModel
        let viewModel = SmartDeviceViewModel(makeFetchAllSmartDeviceUseCase, makeAddSmartDeviceUseCase, makeRemoveSmartDevicesUseCase, makeSearchSmartDevicesUseCase)
        return viewModel
    }
}
