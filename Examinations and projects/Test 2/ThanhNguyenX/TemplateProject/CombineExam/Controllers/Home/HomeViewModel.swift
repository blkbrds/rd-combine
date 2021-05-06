//
//  HomeViewModel.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import Foundation
import Combine

final class HomeViewModel {
    var users: [Cocktail] = []
    var filteredUser: [Cocktail] = []
    var cancellables: Set<AnyCancellable> = []

    func numberOfItems(inSection section: Int) -> Int {
        return self.filteredUser.count
    }

    @discardableResult
    func getAPI(searchText: String = "") -> Future<Void, APIError> {
        let trimmedString = searchText.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
        return Future { [weak self] resolve in
            guard let self = self else {
                return resolve(.failure(.unknown))
            }
            guard let url = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/search.php?s=\(trimmedString)") else {
                return resolve(.failure(.maintenance))
            }
            let cocktail = URLSession.shared.dataTaskPublisher(for: url)
            let _ = cocktail
                .tryMap({ output in
                    guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                        throw APIError.badRequest
                    }
                    return output.data
                })
                .decode(type: Drinks.self, decoder: JSONDecoder())
                .mapError({ error -> APIError in
                    switch error {
                    case is URLError:
                        return .maintenance
                    case is DecodingError:
                        return .decodingError
                    default:
                        return error as? APIError ?? .unknown
                    }
                })
                .sink { completion in
                    print(completion)
                } receiveValue: { value in
                    self.users = value.cocktail
                    self.filteredUser = value.cocktail
                    resolve(.success(()))
                }
                .store(in: &self.cancellables)
        }
    }
}
