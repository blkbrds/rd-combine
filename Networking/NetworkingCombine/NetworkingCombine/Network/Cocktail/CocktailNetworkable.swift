//
//  CocktailNetworkable.swift
//  NetworkingCombine
//
//  Created by MBA0253P on 4/14/21.
//

import Foundation
import Combine

protocol CocktailNetworkable {

    func getCocktails(name: String) -> AnyPublisher<CocktailNetworkManager.DrinkResponseData, Error>
}
