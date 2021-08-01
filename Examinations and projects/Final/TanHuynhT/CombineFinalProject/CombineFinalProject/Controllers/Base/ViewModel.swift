//
//  ViewModel.swift
//  CombineFinalProject
//
//  Created by Tan Huynh T. VN.Danang on 7/31/21.
//

import Combine

protocol ViewModelType {

    var isLoading: CurrentValueSubject<Bool, Never> { get }
    var subscriptions: Set<AnyCancellable> { get }
}
