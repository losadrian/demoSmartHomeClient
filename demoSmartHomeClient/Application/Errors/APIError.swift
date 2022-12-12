import Foundation

enum APIError: ApplicationLocalizedError {
    case unknown, invalidResponse, unauthenticated, decoderError, apiError(reason: ErrorResponseModel)
    
    var errorDescription: String? {
        switch self {
        case .unknown, .invalidResponse, .decoderError:
            return "Communication error"
        case .unauthenticated:
            return "Authentication Error"
        case .apiError(reason: _):
            return "Error"
        }
    }
    
    var failureReason: String? {
        switch self {
        case .unknown, .invalidResponse, .decoderError:
            return "Something went wrong while connecting to the server."
        case .unauthenticated:
            return "Authentication is required. Please log in."
        case .apiError(reason: let reason):
            return reason.errorMessage
        }
    }
}
