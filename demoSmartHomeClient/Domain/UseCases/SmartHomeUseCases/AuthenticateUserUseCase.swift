import Foundation

typealias AuthenticateUserUseCaseFactory = (AuthenticateUserUseCase.RequestValue, @escaping (AuthenticateUserUseCase.ResultValue) -> Void
) -> UseCase

final class AuthenticateUserUseCase: UseCase {
    // MARK: - RequestValue
    struct RequestValue {
        let password: String
    }
    // MARK: - ResultValue
    typealias ResultValue = (Result<Bool, Error>)
    
    // MARK: - Private properties
    private let requestValue: RequestValue
    private let completion: (ResultValue) -> Void
    private let credentialsRepository: CredentialsRepository
    private let smartHomeRepository: SmartHomeRepository
    
    // MARK: - Initializers
    init(requestValue: RequestValue,
         completion: @escaping (ResultValue) -> Void,
         credentialsRepository: CredentialsRepository,
         smartHomeRepository: SmartHomeRepository) {
        
        self.requestValue = requestValue
        self.completion = completion
        self.credentialsRepository = credentialsRepository
        self.smartHomeRepository = smartHomeRepository
    }
    
    // MARK: - Executor
    func execute() {
        smartHomeRepository.getCredentials(byPassword: requestValue.password) { result in
            switch result {
            case .success(let smartHomeAuthCredential):
                let isAccessTokenSaved = self.credentialsRepository.setAccessToken(token: smartHomeAuthCredential.accessToken)
                if isAccessTokenSaved {
                    self.completion(.success(isAccessTokenSaved))
                }
            case .failure(let error):
                self.completion(.failure(error))
            }
        }
    }
}
