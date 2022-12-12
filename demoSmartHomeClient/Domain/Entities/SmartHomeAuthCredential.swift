struct SmartHomeAuthCredential: Codable, Hashable {
    let accessToken: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}
