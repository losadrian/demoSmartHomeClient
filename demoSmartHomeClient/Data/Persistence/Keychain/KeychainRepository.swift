import Foundation

final class KeychainRepository: CredentialsRepository {
    
    static let shared = KeychainRepository()
    
    private init() {}
    
    func getAccessToken() -> String? {
        let keychainItemQuery = [
            kSecAttrAccount: "smarthomes",
            kSecClass: kSecClassGenericPassword,
            kSecMatchLimit: kSecMatchLimitOne,
            kSecReturnData: true
        ] as CFDictionary
        
        var ref: AnyObject?
        
        let status = SecItemCopyMatching(keychainItemQuery, &ref)
        if status == 0 {
            if let result = ref as? Data {
                let accessToken = String(data: result, encoding: .utf8)!
                return accessToken
            }
        }
        
        return nil
    }
    
    func setAccessToken(token accessToken: String) -> Bool {
        _ = removeAccessToken()
        let keychainItemQuery = [
            kSecValueData: accessToken.data(using: .utf8)!,
            kSecAttrAccount: "smarthomes",
            kSecClass: kSecClassGenericPassword
        ] as CFDictionary
        
        let status = SecItemAdd(keychainItemQuery, nil)
        guard status != errSecDuplicateItem else {
            return false
        }
        guard status == errSecSuccess else {
            return false
        }
        
        if let accessTokenFromUserDefaults = getAccessToken() {
            return accessToken == accessTokenFromUserDefaults
        }
        
        return false
    }
    
    func removeAccessToken() -> Bool {
        let keychainItemQuery = [
            kSecAttrAccount: "smarthomes",
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as CFDictionary
        
        let status = SecItemDelete(keychainItemQuery as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            return false
        }
        
        return true
    }
}
