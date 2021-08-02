//
//  RepositoryType.swift
//  Platform
//
//  Created by Quan Bui T on 2021-07-23.
//  Copyright © 2021 Monstar-Lab Inc. All rights reserved.
//

import Domain
import Combine

enum RepositoryError: Error {
    case queryFailed(Error)
    case saveFailed
    case deleteFailed
}

protocol RepositoryType: class {
    associatedtype T
    func queryAll(_ completion: @escaping (Result<[T], Error>) -> Void)
    func query(withId id: String, completion: @escaping (Result<T, Error>) -> Void)
    func query(withQueryItems queryItems: [URLQueryItem], completion: @escaping (Result<[T], Error>) -> Void)
    func save(entity: T, completion: @escaping (Error?) -> Void)
    func delete(entity: T, completion: @escaping (Error?) -> Void)
}

extension RepositoryType where Self: Combinable {

    func queryPublisherForAll() -> AnyPublisher<[T], Error> {
        Future(queryAll).eraseToAnyPublisher()
    }

    func queryPublisher(forId id: String) -> AnyPublisher<T, Error> {
        Future { promise in
            self.query(withId: id) { result in
                promise(result)
            }
        }.eraseToAnyPublisher()
    }

    func queryPublisher(forQueryItems queryItems: [URLQueryItem]) -> AnyPublisher<[T], Error> {
        Future { promise in
            self.query(withQueryItems: queryItems) { result in
                promise(result)
            }
        }.eraseToAnyPublisher()
    }

    func savePublisher(for entity: T) -> AnyPublisher<Void, Error> {
        Future { promise in
            self.save(entity: entity) { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }

    func deletePublisher(for entity: T) -> AnyPublisher<Void, Error> {
        Future { promise in
            self.delete(entity: entity) { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }
}
