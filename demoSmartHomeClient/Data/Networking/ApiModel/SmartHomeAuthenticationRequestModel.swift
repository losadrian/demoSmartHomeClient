import Foundation

struct SmartHomeAuthenticationRequestModel: Codable {
    let smartHomePassword: String
    
    enum CodingKeys: String, CodingKey {
        case smartHomePassword = "password"
    }
}
