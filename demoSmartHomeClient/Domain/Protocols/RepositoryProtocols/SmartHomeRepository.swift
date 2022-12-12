protocol SmartHomeRepository {
    func getCredentials(byPassword password: String, completion: @escaping (Result<SmartHomeAuthCredential, Error>) -> Void)
    func getSmarthomes(completion: @escaping (Result<SmartHomeListResponseModel, Error>) -> Void)
}
