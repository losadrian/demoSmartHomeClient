struct AddDeviceRequestModel: Codable {
    let communication, manufacturer, productName: String

    enum CodingKeys: String, CodingKey {
        case communication, manufacturer
        case productName = "product_name"
    }
}
