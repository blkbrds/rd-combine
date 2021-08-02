//
//  API.Authentication.swift
//  TheMovieCombineApp
//
//  Created by Toan Nguyen D. [4] VN.Danang on 28/07/2021.
//

import Foundation
import Combine

extension API.Authentication {

    static func getRequestToken () -> Future<String, CustomError> {
        Future<String, CustomError> {
            promise in
            guard let url = URL(string: API.Path.Authentication.pathRequestToken) else {
                return
            }
            let request = NSMutableURLRequest(url: url,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "GET"
            let session = URLSession.shared
            session.dataTaskPublisher(for: request as URLRequest)
                .sink(receiveCompletion: { (completion) in
                print(completion)
            }, receiveValue: { (data, response) in
                DispatchQueue.main.async {
                    let httpURLResponse = response as? HTTPURLResponse
                    if httpURLResponse?.statusCode == 200 {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: [])
                            guard let data = json as? [String: Any],
                                  let token = data["request_token"] as? String else {
                                return
                            }
                            print("Data1", data)
                            UserDefaults.standard.setValue(token, forKey: "requestToken")
                            promise(.success(token))
                            print("RequestToken:",token)
                        } catch {
//                            handle later
                        }
                    }
                }
            }).store(in: &API.subscriptions)
        }

    }
}
