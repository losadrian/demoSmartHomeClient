import Foundation

protocol ApplicationLocalizedError: LocalizedError {
    var errorDescription: String? { get }
    var failureReason: String? { get }
}
