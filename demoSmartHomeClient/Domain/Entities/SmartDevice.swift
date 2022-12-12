struct SmartDevice: Codable, Hashable {
    let communication: String
    let deviceID: Int
    let manufacturer: String
    let productName: String

    enum CodingKeys: String, CodingKey {
        case communication
        case deviceID = "device_id"
        case manufacturer
        case productName = "product_name"
    }
}
