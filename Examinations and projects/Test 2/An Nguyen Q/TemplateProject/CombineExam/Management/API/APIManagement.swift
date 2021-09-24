//
//  APIManagement.swift
//  CombineExam
//
//  Created by MBA0217 on 4/28/21.
//

import Foundation
import Combine

struct APIManagement {
    enum EndPoint {
//        static var baseUrl = URLComponents(string: "https://www.thecocktaildb.com/api/json/v1/1/search.php")!//URL(string: "https://www.thecocktaildb.com/api/json/v1/1/search.php?s=")!
        
        case search(String)
        
        var url: URL {
            switch self {
            case .search(let keyword):
                let queryItems = [URLQueryItem(name: "s", value: keyword)]
                var urlComps = URLComponents(string: "https://www.thecocktaildb.com/api/json/v1/1/search.php")!
                urlComps.queryItems = queryItems
                let result = urlComps.url!
                
                print("=======",result)
                return result
            }
        }
    }
    private let decoder = JSONDecoder()
    private let apiQueue = DispatchQueue(label: "API", qos: .default, attributes: .concurrent)

    func getListDrink(_ keyword: String) -> AnyPublisher<Drinks, APIError> {
        return URLSession.shared.dataTaskPublisher(for: EndPoint.search(keyword).url)
            .subscribe(on: apiQueue)
            .map {
//                print("----------", $0)
                return $0.data
            }
            .decode(type: Drinks.self, decoder: JSONDecoder())
            .mapError({ error -> APIError in
                switch error {
                case is URLError:
                    return .errorURL
                case is DecodingError:
//                    print("-------", error.localizedDescription)
                    return .errorParsing
                default:
                    return error as? APIError ?? .unknown
                }
            })
            .eraseToAnyPublisher()
    }
}
