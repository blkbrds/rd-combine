//
//  HomeViewModel.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import Foundation
import Combine

final class HomeViewModel {
    
    let drinks: CurrentValueSubject<[Drink], Never> = CurrentValueSubject<[Drink], Never>([])
    let searchKey: CurrentValueSubject<String, Never> = CurrentValueSubject<String, Never>("")
    var subscription = Set<AnyCancellable>()
    
    init() {
        searchKey.throttle(for: 1, scheduler: RunLoop.main, latest: true).sink { (key) in
            self.getCooktail(key: key).sink { (completion) in
                print(completion)
            } receiveValue: { (value) in
                self.drinks.send(value.drinks)
            }.store(in: &self.subscription)
        }.store(in: &subscription)
    }
        
    func getCooktail(key: String) -> AnyPublisher<DrinksRespone, Error> {
        guard let url = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/search.php?s=\(key)") else {
            fatalError("Invalid URL")
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map {
                print($0.data)
                return $0.data
            }
            .decode(type: DrinksRespone.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
