//
//  API.Login.swift
//  TheMovieCombineApp
//
//  Created by Toan Nguyen D. [4] VN.Danang on 28/07/2021.
//

import Foundation
import Combine

extension API.Login {

    static func loginAccount (username: String, pwd: String) -> Future<StatusResponseAPI, CustomError> {
        return Future<StatusResponseAPI, CustomError> {
            promise in
            guard let url = URL(string: API.Path.Login.path) else {
                return
            }
            let request = NSMutableURLRequest(url: url,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "POST"
            let token = (UserDefaults.standard.value(forKey: "requestToken") as? String) ?? ""
            let params = ["username": username,
                                             "password": pwd,
                                             "request_token": token]
            request.httpBody = params.percentEncoded()
            let session = URLSession.shared
            session.dataTaskPublisher(for: request as URLRequest)
                .sink(receiveCompletion: { (err) in
                }, receiveValue: { (data, response) in
                    DispatchQueue.main.async {
                        let httpURLResponse = response as? HTTPURLResponse
                        if httpURLResponse?.statusCode == 200 {
                            print("login api success")
                            promise(.success(.success))
                        } else if httpURLResponse?.statusCode == 401 {
                            do {
                                let json = try JSONSerialization.jsonObject(with: data, options: [])
                                guard let data = json as? [String: Any],
                                      let code = data["status_code"] as? Int else { return }
                                print("Data", data)
                                promise(.success(.failure(code: code)))
                            } catch {
                                // handle later
                            }
                        } else {
                            do {
                            let json = try JSONSerialization.jsonObject(with: data, options: [])

                                print("json", json)
//                            promise(.success(.failure(code: code)))
                        } catch {
                            // handle later
                        }
                            print("status code #", httpURLResponse?.statusCode)
                        }
                    }
                }).store(in: &API.subscriptions)
        }
    }
}
