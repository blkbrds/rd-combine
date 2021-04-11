//
//  TrendingCellViewModel.swift
//  List-NavigationDemo
//
//  Created by MBA0321 on 3/16/21.
//

import Combine
import Foundation

class TrendingCellViewModel: ObservableObject {


    var restaurant: Restaurant
    
    init(item: Restaurant) {
        self.restaurant = item
    }
}
