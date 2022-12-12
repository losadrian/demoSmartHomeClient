struct SmartHome: Codable, Hashable {
    let homeID: Int
    let homeName: String
    
    enum CodingKeys: String, CodingKey {
        case homeID = "home_id"
        case homeName = "home_name"
    }
}
