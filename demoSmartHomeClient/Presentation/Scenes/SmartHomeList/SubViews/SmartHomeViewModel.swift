import Foundation

final class SmartHomeViewModel: ObservableObject {
    // MARK: - Binding Properties
    @Published var smartDevices : [SmartDevice] = []
    @Published var deviceID: Int = -1
    @Published var password: String = ""
    @Published var isLoginViewPresented: Bool = false
    @Published var errorInViewModel: Error?
    
    // MARK: - Private properties
    private let smartHome: SmartHome
    private let authenticateUserUseCaseFactory: AuthenticateUserUseCaseFactory
    private let deauthenticateUserUseCaseFactory: DeauthenticateUserUseCaseFactory
    private let fetchDevicesOfSmartHomeUseCaseFactory: FetchDevicesOfSmartHomeUseCaseFactory
    private let removeDevicesFromSmartHomeUseCaseFactory: RemoveDevicesFromSmartHomeUseCaseFactory
    
    // MARK: - Initializers
    init(smartHome: SmartHome,
         _ authenticateUserUseCaseFactory: @escaping AuthenticateUserUseCaseFactory,
         _ deauthenticateUserUseCaseFactory: @escaping DeauthenticateUserUseCaseFactory,
         _ fetchDevicesOfSmartHomeUseCaseFactory: @escaping FetchDevicesOfSmartHomeUseCaseFactory,
         _ removeDevicesFromSmartHomeUseCaseFactory: @escaping RemoveDevicesFromSmartHomeUseCaseFactory) {
        self.smartHome = smartHome
        self.authenticateUserUseCaseFactory = authenticateUserUseCaseFactory
        self.deauthenticateUserUseCaseFactory = deauthenticateUserUseCaseFactory
        self.fetchDevicesOfSmartHomeUseCaseFactory = fetchDevicesOfSmartHomeUseCaseFactory
        self.removeDevicesFromSmartHomeUseCaseFactory = removeDevicesFromSmartHomeUseCaseFactory
    }
    
    // MARK: - Public functions
    func authentication() {
        let authenticateFromAPICompletion : (Result<Bool, Error>) -> Void = { result in
            switch result {
            case .success( _):
                self.isLoginViewPresented = false
                self.password = ""
                self.getDevices()
            case .failure(let error):
                switch error {
                case is ApplicationLocalizedError:
                    let localizedAlertError = error as! ApplicationLocalizedError
                    self.errorInViewModel = localizedAlertError
                default:
                    self.errorInViewModel = ApplicationError.defaultErrorHasBeenOccured
                }
            }
        }
        
        let request = AuthenticateUserUseCase.RequestValue(password: password)
        let useCase = authenticateUserUseCaseFactory(request, authenticateFromAPICompletion)
        useCase.execute()
    }
    
    func deauthentication() {
        let deauthenticationCompletion : (Result<Void, Error>) -> Void = { result in
            switch result {
            case .success():
                    self.isLoginViewPresented = true
            case .failure(let error):
                switch error {
                case is ApplicationLocalizedError:
                    let localizedAlertError = error as! ApplicationLocalizedError
                    self.errorInViewModel = localizedAlertError
                default:
                    self.errorInViewModel = ApplicationError.defaultErrorHasBeenOccured
                }
            }
        }
        
        let useCase = deauthenticateUserUseCaseFactory(deauthenticationCompletion)
        useCase.execute()
    }
    
    func getDevices() {
        let getDevicesFromAPICompletion : (Result<[SmartDevice], Error>) -> Void = { result in
            switch result {
            case .success(let getDevicesResponse):
                self.isLoginViewPresented = false
                self.smartDevices = getDevicesResponse
            case .failure(let error):
                switch error {
                case APIError.unauthenticated:
                    self.isLoginViewPresented = true
                case is ApplicationLocalizedError:
                    let localizedAlertError = error as! ApplicationLocalizedError
                    self.errorInViewModel = localizedAlertError
                default:
                    self.errorInViewModel = ApplicationError.defaultErrorHasBeenOccured
                }
            }
        }
        let request = FetchDevicesOfSmartHomeUseCase.RequestValue(smartHome: smartHome)
        let useCase = fetchDevicesOfSmartHomeUseCaseFactory(request, getDevicesFromAPICompletion)
        useCase.execute()
    }
    
    func removeDevice(at offsets: IndexSet) {
        let removeDeviceFromAPICompletion : (Result<Bool, Error>) -> Void = { result in
            switch result {
            case .success(let isRemoveDeviceFromSmartHomeSuccess):
                if isRemoveDeviceFromSmartHomeSuccess {
                    self.smartDevices.remove(atOffsets: offsets)
                    self.getDevices()
                }
            case .failure(let error):
                switch error {
                case APIError.unauthenticated:
                    self.isLoginViewPresented = true
                case is ApplicationLocalizedError:
                    let localizedAlertError = error as! ApplicationLocalizedError
                    self.errorInViewModel = localizedAlertError
                default:
                    self.errorInViewModel = ApplicationError.defaultErrorHasBeenOccured
                }
            }
        }
        
        let devicesToRemove = Set(offsets.map { smartDevices[$0] })
        let request = RemoveDevicesFromSmartHomeUseCase.RequestValue(smartHome: smartHome, devicesToRemove: devicesToRemove)
        let useCase = removeDevicesFromSmartHomeUseCaseFactory(request, removeDeviceFromAPICompletion)
        useCase.execute()
    }
}
