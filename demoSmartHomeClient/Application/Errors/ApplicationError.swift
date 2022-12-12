import Foundation

enum ApplicationError: ApplicationLocalizedError {
    case allDevicePropertyFieldHasToBeFilled
    case aPropertyFieldHasToBeFilledToSearchDevices
    case defaultErrorWithFailureReason(reason: String)
    case defaultErrorHasBeenOccured
    
    var errorDescription: String? {
        switch self {
        case .allDevicePropertyFieldHasToBeFilled:
            return "Missing fields"
        case .aPropertyFieldHasToBeFilledToSearchDevices:
            return "A missing field"
        case .defaultErrorWithFailureReason(reason: _):
            return "Error"
        case .defaultErrorHasBeenOccured:
            return "Error"
        }
    }
    
    var failureReason: String? {
        switch self {
        case .allDevicePropertyFieldHasToBeFilled:
            return "All fields is required."
        case .aPropertyFieldHasToBeFilledToSearchDevices:
            return "At least one field is required (product name, manufacturer, communication)."
        case .defaultErrorWithFailureReason(reason: let reason):
            return reason
        case .defaultErrorHasBeenOccured:
            return "Something wrong happened."
        }
    }
}
