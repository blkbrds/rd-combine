//
//  API.CastOfMovie.swift
//  TheMovieCombineApp
//
//  Created by Toan Nguyen D. [4] VN.Danang on 02/08/2021.
//

import Foundation
import Combine
import ObjectMapper

extension API.Detail {
    static func getCast(idMovie: Int) -> Future<[Cast], CustomError> {
        return Future<[Cast], CustomError> {
            promise in
            API.Path.CastOfMovie.idMovie = idMovie
            guard let url = URL(string: API.Path.CastOfMovie.path) else { return }
            let request = NSMutableURLRequest(url: url,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "GET"
            let session = URLSession.shared
            session.dataTaskPublisher(for: request as URLRequest)
                .sink(receiveCompletion: { (err) in
                }, receiveValue: { (data, response) in
                    DispatchQueue.main.async {
                        let httpURLResponse = response as? HTTPURLResponse
                        if httpURLResponse?.statusCode == 200 {
                            do {
                                let json = try JSONSerialization.jsonObject(with: data, options: [])
                                guard let data = json as? [String: Any],
                                      let results = data["cast"] as? [[String: Any]] else { return }
                                print("Data", data)
                                let casts = Mapper<Cast>().mapArray(JSONArray: results)
                                promise(.success(casts))
                            } catch {
                                    // handle later
                                }
                        } else if httpURLResponse?.statusCode == 401 {
                            do {
                                let json = try JSONSerialization.jsonObject(with: data, options: [])
                                guard let data = json as? [String: Any],
                                      let code = data["status_code"] as? Int else { return }
                                print("Data", data)
                            } catch {
                                // handle later
                            }
                        } else {
                            print("status code #", httpURLResponse?.statusCode)
                        }
                    }
                }).store(in: &API.subscriptions)
        }
    }
}

