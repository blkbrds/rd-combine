
//
//  NetworkManager.swift
//  Foody
//
//  Created by MBA0283F on 3/23/21.
//

import Moya
import Combine
import Foundation

struct NetworkProvider {
    static var shared: NetworkProvider = NetworkProvider()
    
    static var isRefreshToken: Bool = false
    
    private var provider = MoyaProvider<Router>(plugins: [NetworkLoggerPlugin()])
    private init() { }
    
    func request(_ api: Router) -> AnyPublisher<Data, CommonError> {
        return Future<Data, CommonError> { promise in
            self.provider.request(api) { (result) in
                switch result {
                case .success(let response):
                    print("DEBUG - Response: ", response.data.toJSON() ?? "")
                    if response.data.toJSON() == nil {
                        promise(.failure(.unknown("Data is empty.")))
                    }
                    if 400...499 ~= response.statusCode {
                        if response.statusCode == 401 {
                            promise(.failure(.expiredToken))
                        }
                        promise(.failure(.unknown(response.messageError)))
                    } else {
                        promise(.success(response.data))
                    }
                case .failure(let error):
                    let errorDescription = error.errorDescription?.split(separator: ":").last ?? "Unknown"
                    promise(.failure(.unknown(String(errorDescription))))
                }
            }
        }
        .print("DEBUG - NetworkProvider")
        .timeout(.seconds(Constants.TIMEOUT), scheduler: DispatchQueue.global(), customError: { .timeout })
        .retry(Constants.RETRYTIME)
        .subscribe(on: DispatchQueue.global())
        .eraseToAnyPublisher()
    }
    
    func refreshToken(completion: @escaping (MoyaError?) -> Void) {
        NetworkProvider.isRefreshToken = true
        provider.request(.refreshToken) { (result) in
            switch result {
            case .success(let response):
                NetworkProvider.isRefreshToken = false
                if let json = response.data.toJSON() as? [String: Any] {
                    Session.shared.accessToken = json["accessToken"] as? String
                }
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }
}
