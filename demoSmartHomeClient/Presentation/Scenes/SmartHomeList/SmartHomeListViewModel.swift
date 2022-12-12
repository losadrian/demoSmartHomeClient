import Foundation

final class SmartHomeListViewModel: ObservableObject {
    // MARK: - Binding Properties
    @Published var smartHomes : [SmartHome] = []
    @Published var errorInViewModel: Error?
    
    // MARK: - Private properties
    private let fetchAllSmartHomeUseCaseFactory: FetchAllSmartHomeUseCaseFactory
    
    // MARK: - Initializers
    init(_ fetchAllSmartHomeUseCaseFactory: @escaping FetchAllSmartHomeUseCaseFactory) {
        self.fetchAllSmartHomeUseCaseFactory = fetchAllSmartHomeUseCaseFactory
    }
    
    // MARK: - Public functions
    func getSmartHomes() {
        let getSmartHomesFromRepoCompletion : (Result<SmartHomeListResponseModel, Error>) -> Void = { result in
            switch result {
            case .success(let getSmartHomesResponse):
                self.smartHomes = getSmartHomesResponse
                self.errorInViewModel = nil
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
        let useCase = fetchAllSmartHomeUseCaseFactory(getSmartHomesFromRepoCompletion)
        useCase.execute()
    }
}
