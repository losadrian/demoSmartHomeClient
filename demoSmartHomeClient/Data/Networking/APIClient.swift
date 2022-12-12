import Foundation
import Combine

final class APIClient: APIClientType {
    
    private var cancellationToken: AnyCancellable?
    
    func cancel() {
        if let token = cancellationToken {
            token.cancel()
        }
    }
}

// MARK: - SmartHomeRepository
extension APIClient: SmartHomeRepository {
    func getCredentials(byPassword password: String, completion: @escaping (Result<SmartHomeAuthCredential, Error>) -> Void) {
        let getAccessTokenPath = PathBuilder().smarthome().authentication().build()
        let smartHomeAuthenticationRequestModel = SmartHomeAuthenticationRequestModel(smartHomePassword: password)
        let getAccessTokenRequest = RequestBuilder(networkMethod: .POST, path: getAccessTokenPath).model(smartHomeAuthenticationRequestModel).build()
        let getAccessTokenPublisher = NetworkPublisher(urlRequest: getAccessTokenRequest).anyPublisher(type: SmartHomeAuthCredential.self)
        
        cancellationToken = getAccessTokenPublisher.sink(receiveCompletion: { cancellableCompletion in
            if case let .failure(error as APIError) = cancellableCompletion {
                completion(.failure(error))
            }
        }, receiveValue: { getAccessTokenResponse in
            completion(.success(getAccessTokenResponse))
        })
    }
    
    func getSmarthomes(completion: @escaping (Result<SmartHomeListResponseModel, Error>) -> Void) {
        let getSmarthomesPath = PathBuilder().smarthome().build()
        let getSmarthomesRequest = RequestBuilder(networkMethod: .GET, path: getSmarthomesPath).build()
        let getSmarthomesPublisher = NetworkPublisher(urlRequest: getSmarthomesRequest).anyPublisher(type: SmartHomeListResponseModel.self)
        
        cancellationToken = getSmarthomesPublisher.sink(receiveCompletion: { cancellableCompletion in
            if case let .failure(error as APIError) = cancellableCompletion {
                completion(.failure(error))
            }
        }, receiveValue: { getSmarthomesResponse in
            completion(.success(getSmarthomesResponse))
        })
    }
}

// MARK: - SmartDeviceRepository
extension APIClient: SmartDeviceRepository {
    func getDevices(completion: @escaping (Result<DeviceListResponseModel, Error>) -> Void) {
        let getDevicesPath = PathBuilder().device().build()
        let getDevicesRequest = RequestBuilder(networkMethod: .GET, path: getDevicesPath).build()
        
        let getDevicesPublisher = NetworkPublisher(urlRequest: getDevicesRequest).anyPublisher(type: DeviceListResponseModel.self)
        
        cancellationToken = getDevicesPublisher.sink(receiveCompletion: { cancellableCompletion in
            if case let .failure(error as APIError) = cancellableCompletion {
                completion(.failure(error))
            }
        }, receiveValue: { getDevicesResponse in
            completion(.success(getDevicesResponse))
        })
    }
    
    func getDevices(bySmartHomeId homeID: Int, completion: @escaping (Result<DeviceListResponseModel, Error>) -> Void) {
        let getDevicesBySmartHomeIdPath = PathBuilder().smarthome().id(id: String(homeID)).device().build()
        let getDevicesBySmartHomeIdRequest = RequestBuilder(networkMethod: .GET, path: getDevicesBySmartHomeIdPath).withAuth().build()
        
        let getDevicesBySmartHomeIdPublisher = NetworkPublisher(urlRequest: getDevicesBySmartHomeIdRequest).anyPublisher(type: DeviceListResponseModel.self)
        
        cancellationToken = getDevicesBySmartHomeIdPublisher.sink(receiveCompletion: { cancellableCompletion in
            if case let .failure(error as APIError) = cancellableCompletion {
                completion(.failure(error))
            }
        }, receiveValue: { getDevicesBySmartHomeIdResponse in
            completion(.success(getDevicesBySmartHomeIdResponse))
        })
    }
    
    func addDevice(smartDevice: SmartDevice, completion: @escaping (Result<Bool, Error>) -> Void) {
        let addDevicePath = PathBuilder().device().build()
        let addDeviceRequestModel = AddDeviceRequestModel(communication: smartDevice.communication, manufacturer: smartDevice.manufacturer, productName: smartDevice.productName)
        let addDeviceRequest = RequestBuilder(networkMethod: .POST, path: addDevicePath).model(addDeviceRequestModel).build()
        
        let addDevicePublisher = NetworkPublisher(urlRequest: addDeviceRequest).anyPublisher(type: GeneralSuccessResponseModel.self)
        
        cancellationToken = addDevicePublisher.sink(receiveCompletion: { cancellableCompletion in
            if case let .failure(error as APIError) = cancellableCompletion {
                completion(.failure(error))
            }
        }, receiveValue: { addDeviceResponse in
            completion(.success(addDeviceResponse.success))
        })
    }
    
    func removeDevice(byDeviceId deviceID: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        let removeDevicePath = PathBuilder().device().id(id: String(deviceID)).build()
        let removeDeviceRequest = RequestBuilder(networkMethod: .DELETE, path: removeDevicePath).build()
        let removeDevicePublisher = NetworkPublisher(urlRequest: removeDeviceRequest).anyPublisher(type: GeneralSuccessResponseModel.self)
        
        cancellationToken = removeDevicePublisher.sink(receiveCompletion: { cancellableCompletion in
            if case let .failure(error as APIError) = cancellableCompletion {
                completion(.failure(error))
            }
        }, receiveValue: { removeDeviceResponse in
            completion(.success(removeDeviceResponse.success))
        })
    }
    
    func removeDevice(bySmartHomeId homeID: Int, andByDeviceId deviceID: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        let removeDeviceFromSmartHomePath = PathBuilder().smarthome().id(id: String(homeID)).device().id(id: String(deviceID)).build()
        let removeDeviceFromSmartHomeRequest = RequestBuilder(networkMethod: .DELETE, path: removeDeviceFromSmartHomePath).build()
        let removeDeviceFromSmartHomePublisher = NetworkPublisher(urlRequest: removeDeviceFromSmartHomeRequest).anyPublisher(type: GeneralSuccessResponseModel.self)
        
        cancellationToken = removeDeviceFromSmartHomePublisher.sink(receiveCompletion: { cancellableCompletion in
            if case let .failure(error as APIError) = cancellableCompletion {
                completion(.failure(error))
            }
        }, receiveValue: { removeDeviceFromSmartHomeResponse in
            completion(.success(removeDeviceFromSmartHomeResponse.success))
        })
    }
    
    func searchDevices(byCommunication communication: String?, byManufacturer manufacturer: String?, byProductName productName: String?, completion: @escaping (Result<[SmartDevice], Error>) -> Void) {
        var queryItems: [String : String] = [:]
        if let communicationToQuery = communication {
            queryItems["communication"] = communicationToQuery
        }
        if let manufacturerToQuery = manufacturer {
            queryItems["manufacturer"] = manufacturerToQuery
        }
        if let productNameToQery = productName {
            queryItems["productName"] = productNameToQery
        }
        
        let getDevicesByQueriesPath = PathBuilder().device().build()
        let getDevicesByQueriesRequest = RequestBuilder(networkMethod: .GET, path: getDevicesByQueriesPath).queryItems(queryItems).build()
        let getDevicesByQueriesPublisher = NetworkPublisher(urlRequest: getDevicesByQueriesRequest).anyPublisher(type: DeviceListResponseModel.self)
        
        cancellationToken = getDevicesByQueriesPublisher.sink(receiveCompletion: { cancellableCompletion in
            if case let .failure(error as APIError) = cancellableCompletion {
                completion(.failure(error))
            }
        }, receiveValue: { getDevicesByQueriesResponse in
            completion(.success(getDevicesByQueriesResponse))
        })
    }
}


