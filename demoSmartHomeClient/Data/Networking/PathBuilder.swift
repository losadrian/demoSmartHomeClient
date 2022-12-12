import Foundation

class PathBuilder {
    // MARK: - Private properties
    private var path : String
    
    // MARK: - Initializers
    init() {
        self.path = ""
    }
    
    // MARK: - Path elements
    @discardableResult
    func device() -> PathBuilder {
        path.append("/device")
        return self
    }
    
    @discardableResult
    func smarthome() -> PathBuilder {
        path.append("/smarthome")
        return self
    }
    
    @discardableResult
    func authentication() -> PathBuilder {
        path.append("/authentication")
        return self
    }
    
    @discardableResult
    func id(id: String) -> PathBuilder {
        path.append("/\(id)")
        return self
    }
    
    // MARK: - BUILD
    func build() -> String {
        return self.path
    }
}
