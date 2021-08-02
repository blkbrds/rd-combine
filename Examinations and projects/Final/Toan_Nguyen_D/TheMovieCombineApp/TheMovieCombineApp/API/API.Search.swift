//
//  API.Search.swift
//  TheMovieCombineApp
//
//  Created by Toan Nguyen D. [4] VN.Danang on 31/07/2021.
//

import Foundation
import Combine
import ObjectMapper

extension API.Search {

    static func getMoviesWithSearch(searchKey: String, page: Int = 1) -> Future<[Movie], CustomError> {
        return Future<[Movie], CustomError> {
            promise in
            API.Path.Search.key = searchKey
            API.Path.Search.page = page
            guard let url = URL(string: API.Path.Search.path) else { return }
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
                                      let results = data["results"] as? [[String: Any]] else { return }
                                print("Data", data)
                                let movies = Mapper<Movie>().mapArray(JSONArray: results)
                                for i in movies {
                                    print("id: ", i.id)
                                }
                                promise(.success(movies))
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
