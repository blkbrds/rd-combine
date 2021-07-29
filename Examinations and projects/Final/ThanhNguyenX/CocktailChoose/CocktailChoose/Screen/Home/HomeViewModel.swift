//
//  HomeViewModel.swift
//  CocktailChoose
//
//  Created by Thanh Nguyen X. [4] VN.Danang on 07/20/21.
//

import Foundation
import Combine

final class HomeViewModel: ViewModel {

    enum Section {
        case first
    }

    @Published var users: [Cocktail] = []
    @Published var filteredUser: [Cocktail] = []
    let path: String = "https://www.thecocktaildb.com/api/json/v1/1/search.php?s="

    func numberOfItems(inSection section: Int) -> Int {
        return filteredUser.count
    }

    @discardableResult
    func getCocktailAPI(isLoadMore: Bool = false, searchText: String = "") -> Future<Void, APIError> {
        let trimmedString = searchText.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
        return Future { [weak self] resolve in
            guard let self = self else {
                return resolve(.failure(.unknown))
            }
            guard let url = URL(string: self.path + trimmedString) else {
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
                    switch completion {
                    case .finished:
                        resolve(.success(()))
                    case .failure(let error):
                        resolve(.failure(error))
                    }
                } receiveValue: { value in
                    if isLoadMore, let newCocktail = value.cocktail {
                        self.filteredUser += newCocktail
                    } else if let cocktail = value.cocktail {
                        self.users = cocktail
                        self.filteredUser = cocktail
                    }
                    resolve(.success(()))
                }
                .store(in: &self.subscriptions)
        }
    }
}