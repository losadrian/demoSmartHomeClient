struct GeneralSuccessResponseModel: Codable {
    let message: String?
    let success: Bool

    enum CodingKeys: String, CodingKey {
        case message = "Message"
        case success = "Success"
    }
}
