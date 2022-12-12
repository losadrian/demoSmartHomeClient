import Foundation

typealias DeauthenticateUserUseCaseFactory = (@escaping (DeauthenticateUserUseCase.ResultValue) -> Void
) -> UseCase

final class DeauthenticateUserUseCase: UseCase {
    // MARK: - ResultValue
    typealias ResultValue = (Result<Void, Error>)
    
    // MARK: - Private properties
    private let completion: (ResultValue) -> Void
    private let credentialsRepository: CredentialsRepository
    
    // MARK: - Initializers
    init(completion: @escaping (ResultValue) -> Void,
         credentialsRepository: CredentialsRepository) {
        self.completion = completion
        self.credentialsRepository = credentialsRepository
    }
    
    func execute() {
        let isAccessTokenRemoved = credentialsRepository.removeAccessToken()
        if isAccessTokenRemoved {
            completion(.success(()))
            return
        }
        completion(.failure(ApplicationError.defaultErrorHasBeenOccured))
    }
}
