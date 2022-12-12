import Foundation

final class SmartDeviceViewModel: ObservableObject {
    // MARK: - Binding Properties
    @Published var smartDevices : [SmartDevice] = []
    @Published var queriedSmartDevices : [SmartDevice] = []
    @Published var isAddDeviceSheetPresented : Bool = false
    @Published var isSearchDeviceViewPresented : Bool = false
    @Published var isAddOrSearchDeviceDisabled : Bool = false
    @Published var isSearchDeviceResultEmpty : Bool = false
    @Published var manufacturer : String = ""
    @Published var productName : String = ""
    @Published var communication : String = ""
    @Published var manufacturerToQuery : String = ""
    @Published var productNameToQuery : String = ""
    @Published var communicationToQuery : String = ""
    @Published var errorInViewModel: Error?
    
    
    // MARK: - Private properties
    private let fetchAllSmartDeviceUseCaseFactory: FetchAllSmartDeviceUseCaseFactory
    private let addSmartDeviceUseCaseFactory: AddSmartDeviceUseCaseFactory
    private let removeSmartDevicesUseCaseFactory: RemoveSmartDevicesUseCaseFactory
    private let searchSmartDevicesUseCaseFactory: SearchSmartDevicesUseCaseFactory
    
    // MARK: - Initializers
    init(_ fetchAllSmartDeviceUseCaseFactory: @escaping FetchAllSmartDeviceUseCaseFactory,
         _ addSmartDeviceUseCaseFactory: @escaping AddSmartDeviceUseCaseFactory,
         _ removeSmartDevicesUseCaseFactory: @escaping RemoveSmartDevicesUseCaseFactory,
         _ searchSmartDevicesUseCaseFactory: @escaping SearchSmartDevicesUseCaseFactory) {
        self.fetchAllSmartDeviceUseCaseFactory = fetchAllSmartDeviceUseCaseFactory
        self.addSmartDeviceUseCaseFactory = addSmartDeviceUseCaseFactory
        self.removeSmartDevicesUseCaseFactory = removeSmartDevicesUseCaseFactory
        self.searchSmartDevicesUseCaseFactory = searchSmartDevicesUseCaseFactory
    }
    
    // MARK: - Public functions
    func getDevices() {
        isAddOrSearchDeviceDisabled = false
        let getDevicesFromRepoCompletion : (Result<DeviceListResponseModel, Error>) -> Void = { result in
            switch result {
            case .success(let getDevicesResponse):
                self.smartDevices = getDevicesResponse
            case .failure(let error):
                self.isAddOrSearchDeviceDisabled = true
                switch error {
                case is ApplicationLocalizedError:
                    let localizedAlertError = error as! ApplicationLocalizedError
                    self.errorInViewModel = localizedAlertError
                default:
                    self.errorInViewModel = ApplicationError.defaultErrorHasBeenOccured
                }
            }
        }
        let useCase = fetchAllSmartDeviceUseCaseFactory(getDevicesFromRepoCompletion)
        useCase.execute()
    }
    
    func addDevice() {
        let addDeviceFromAPICompletion : (Result<Bool, Error>) -> Void = { result in
            switch result {
            case .success(let isAddDeviceSuccess):
                if isAddDeviceSuccess {
                    self.isAddDeviceSheetPresented = false
                }
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
        let smartDevice = SmartDevice(communication: communication, deviceID: -1, manufacturer: manufacturer, productName: productName)
        let request = AddSmartDeviceUseCase.RequestValue(smartDevice: smartDevice)
        let useCase = addSmartDeviceUseCaseFactory(request, addDeviceFromAPICompletion)
        useCase.execute()
    }
    
    func removeDevice(at offsets: IndexSet) {
        let removeDeviceFromAPICompletion : (Result<Bool, Error>) -> Void = { result in
            switch result {
            case .success(let isRemoveDeviceSuccess):
                if isRemoveDeviceSuccess {
                    self.smartDevices.remove(atOffsets: offsets)
                    self.getDevices()
                }
            case .failure(let error):
                self.isAddOrSearchDeviceDisabled = true
                switch error {
                case is ApplicationLocalizedError:
                    let localizedAlertError = error as! ApplicationLocalizedError
                    self.errorInViewModel = localizedAlertError
                default:
                    self.errorInViewModel = ApplicationError.defaultErrorHasBeenOccured
                }
            }
        }
        let devicesToRemove = Set(offsets.map { smartDevices[$0] })
        let request = RemoveSmartDevicesUseCase.RequestValue(devicesToRemove: devicesToRemove)
        let useCase = removeSmartDevicesUseCaseFactory(request, removeDeviceFromAPICompletion)
        useCase.execute()
    }
    
    func searchDevices() {
        let searchDevicesFromRepoCompletion : (Result<DeviceListResponseModel, Error>) -> Void = { result in
            switch result {
            case .success(let getDevicesResponse):
                self.isSearchDeviceResultEmpty = getDevicesResponse.isEmpty
                self.queriedSmartDevices = getDevicesResponse
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
        let smartDeviceQuery = (communication: communicationToQuery,
                                manufacturer: manufacturerToQuery,
                                productName: productNameToQuery)
        let request = SearchSmartDevicesUseCase.RequestValue(smartDeviceQuery: smartDeviceQuery)
        let useCase = searchSmartDevicesUseCaseFactory(request, searchDevicesFromRepoCompletion)
        useCase.execute()
    }
}
