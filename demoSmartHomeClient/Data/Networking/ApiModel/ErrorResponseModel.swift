struct ErrorResponseModel: Codable {
    let errorCode: Int
    let errorMessage: String

    enum CodingKeys: String, CodingKey {
        case errorCode = "ErrorCode"
        case errorMessage = "ErrorMessage"
    }
}
