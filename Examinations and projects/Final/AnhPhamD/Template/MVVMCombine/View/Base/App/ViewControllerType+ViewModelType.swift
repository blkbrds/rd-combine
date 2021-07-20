//
//  ViewControllerType+ViewModelType.swift
//  MVVMCombine
//
//  Created by Van Le H. on 6/12/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import Foundation
import Combine

protocol ViewModelType {
    var isLoading: CurrentValueSubject<Bool, Never> { get }
    var subscriptions: Set<AnyCancellable> { get }
}

protocol ViewControllerType {
    var subscriptions: Set<AnyCancellable> { get }
    var viewModelType: ViewModelType? { get }
}
