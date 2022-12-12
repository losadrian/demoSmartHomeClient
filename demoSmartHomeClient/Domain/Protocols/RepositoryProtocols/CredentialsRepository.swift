protocol CredentialsRepository {
    func getAccessToken() -> String?
    func setAccessToken(token accessToken: String) -> Bool
    func removeAccessToken() -> Bool
}
