//
//  StadiumViewModel.swift
//  MVVMCombine
//
//  Created by Tam Nguyen K. T. [7] VN.Danang on 7/24/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import Foundation
import Combine

final class StadiumViewModel: ViewModelType {

    // MARK: - Properties
    var isLoading: CurrentValueSubject<Bool, Never> = .init(false)
    var subscriptions: Set<AnyCancellable> = []

}
