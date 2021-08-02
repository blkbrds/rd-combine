//
//  RemoteRepository.swift
//  Platform
//
//  Created by Quan Bui T on 2021-07-23.
//  Copyright © 2021 Monstar-Lab Inc. All rights reserved.
//

import Domain
import Combine

class RemoteRepository<T: Codable>: RepositoryType, Combinable {

    let network: Networking

    private let baseURL: URL
    private let endpoint: Endpoint
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
//      this is also where you'd set the `keyDecodingStrategy`
//      if you'd be lucky enough to work with a snake_case_endpoint :)
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    private var endpointURL: URL {
        baseURL.appendingPathComponent(endpoint.relativePath)
    }

    init(baseURL: URL, network: Networking, endpoint: Endpoint) {
        self.baseURL = baseURL
        self.network = network
        self.endpoint = endpoint
    }

    func queryAll(_  completion: @escaping (Result<[T], Error>) -> Void) {
        let request = URLRequest(url: self.endpointURL)
        network.send(request) { result in
            switch result {
            case .success(let data):
                do {
                    let list = try self.decoder.decode([T].self, from: data)
                    completion(.success(list))
                } catch let error {
                    completion(.failure(error)) // DecodingError
                }
            case .failure(let error):
                completion(.failure(error)) // NetworkError
            }
        }
    }

    func query(withId id: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard var urlComponents = URLComponents(url: endpointURL, resolvingAgainstBaseURL: false) else {
            return completion(.failure(URLError(.badURL)))
        }

        urlComponents.queryItems = [URLQueryItem(name: "id", value: id)]

        guard let url = urlComponents.url else {
            return completion(.failure(URLError(.badURL)))
        }
        let request = URLRequest(url: url)
        network.send(request) { result in
            switch result {
            case .success(let data):
                do {
                    let item = try self.decoder.decode(ListDetail<T>.self, from: data)
                    completion(.success(item.leagues[0]))
                } catch let error {
                    completion(.failure(error)) // DecodingError
                }
            case .failure(let error):
                completion(.failure(error)) // NetworkError
            }
        }
    }

    func query(withQueryItems queryItems: [URLQueryItem], completion: @escaping (Result<[T], Error>) -> Void) {
        guard var urlComponents = URLComponents(url: endpointURL, resolvingAgainstBaseURL: false) else {
            return completion(.failure(URLError(.badURL)))
        }

        urlComponents.queryItems = queryItems

        guard let url = urlComponents.url else {
            return completion(.failure(URLError(.badURL)))
        }

        let request = URLRequest(url: url)
        self.network.send(request) { result in
            switch result {
            case .success(let data):
                do {
                    let list = try self.decoder.decode(List<T>.self, from: data)
                    completion(.success(list.countrys))
                } catch let error {
                    completion(.failure(error)) // DecodingError
                }
            case .failure(let error):
                completion(.failure(error)) // NetworkError
            }
        }
    }

    func save(entity: T, completion: @escaping (Error?) -> Void) {
        let url = baseURL.appendingPathComponent(endpoint.relativePath)
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue // TODO: What about update PATCH?
        request.httpBody = try? JSONEncoder().encode(entity)
        self.network.send(request) { result in
            switch result {
            case .success(let data):
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    guard let dict = json, let success = dict["success"] as? Bool else {
                        return completion(RepositoryError.saveFailed)
                    }
                    completion(success ? nil : RepositoryError.saveFailed)
                } catch let error {
                    completion(error)
                }
            case .failure(let error):
                completion(error) // NetworkError
            }
        }
    }

    func delete(entity: T, completion: @escaping (Error?) -> Void) {
        let url = baseURL.appendingPathComponent(endpoint.relativePath)
        let request = URLRequest(url: url)
        self.network.send(request) { result in
            switch result {
            case .success(let data):
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    guard let dict = json, let success = dict["success"] as? Bool else {
                        return completion(RepositoryError.deleteFailed)
                    }
                    completion(success ? nil : RepositoryError.deleteFailed)
                } catch let error {
                    completion(error)
                }
            case .failure(let error):
                completion(error) // NetworkError
            }
        }
    }
}

private struct List<T: Decodable>: Decodable {
    var countrys: [T]
    
    enum CodingKeys: String, CodingKey {
        case countrys
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        countrys = try container.decode([T].self, forKey: .countrys)
    }
}

private struct ListDetail<T: Decodable>: Decodable {
    var leagues: [T]
    
    enum CodingKeys: String, CodingKey {
        case leagues
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        leagues = try container.decode([T].self, forKey: .leagues)
    }
}

private extension URL {

    func queryItemAdded(name: String, value: String?) -> URL? {
        return self.queryItemsAdded([URLQueryItem(name: name, value: value)])
    }

    func queryItemsAdded(_ queryItems: [URLQueryItem]) -> URL? {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: nil != self.baseURL) else {
            return nil
        }
        components.queryItems = queryItems + (components.queryItems ?? [])
        return components.url
    }

}
