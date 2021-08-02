//
//  AuthManager.swift
//  TheMovieCombineApp
//
//  Created by Toan Nguyen D. [4] VN.Danang on 27/07/2021.
//

import Foundation
import Combine

struct AuthError: Error {
    var tokenExpired: Int
}

final class AuthManager {

    static var shared = AuthManager()
    var subscriptions = Set<AnyCancellable>()
    var sessionID: String = ""
    @Published var requestToken: String = ""

    init() {
//        getAuthen()
    }

//    func getAuthen() {
//        $requestToken.sink {(completion) in
//                print(completion)
//            } receiveValue: { (token) in
////                print("load1")
////                guard let url = URL(string: API.Path.Authentication.pathAllowAuth) else {
////                    return }
////                print("load")
////                let request = URLRequest(url: url)
////                self?.webView.load(request)
//            }.store(in: &subscriptions)
//    }
}
