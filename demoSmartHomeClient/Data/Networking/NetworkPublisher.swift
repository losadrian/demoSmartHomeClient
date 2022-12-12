import Foundation
import Combine

// MARK: - NetworkPublisher
struct NetworkPublisher {
    let urlRequest: URLRequest
    public func anyPublisher<T:Decodable>(type: T.Type) -> AnyPublisher<T, Error> {
        let decoder = JSONDecoder()
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { output in
                guard let httpUrlResponse = output.response as? HTTPURLResponse else {
                    throw APIError.invalidResponse
                }
                NSLog("httpResponse.statusCode: \(httpUrlResponse.statusCode)")
                if (200..<300) ~= httpUrlResponse.statusCode {
                    if let encodableOutputData = String(data: output.data, encoding: .utf8) {
                        NSLog(" - Response json: - \n\(encodableOutputData)")
                        do {
                            let parsedJSON = try decoder.decode(T.self, from: output.data)
                            NSLog("\n - Parsed json: - \n\(parsedJSON)")
                        } catch {
                            NSLog("\n error in \(T.self): \(error)\n")
                            let errorResponse = try? decoder.decode(ErrorResponseModel.self, from: output.data)
                            if let errorResponse = errorResponse {
                                NSLog("errorResponse.errorCode: \(errorResponse.errorCode)")
                                NSLog("errorResponse.errorMessage: \(errorResponse.errorMessage)")
                                throw APIError.apiError(reason: errorResponse)
                            }
                            throw APIError.decoderError
                        }
                    }
                    return output.data
                }
                else {
                    NSLog("httpResponse NOT Successful")
                    if httpUrlResponse.statusCode == 401 {
                        throw APIError.unauthenticated
                    }
                    else {
                        NSLog("APIError.unknown...")
                        throw APIError.unknown
                    }
                }
            }
            .decode(type: T.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    public func anyPublisher() -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure> {
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
