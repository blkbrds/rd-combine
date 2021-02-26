//
//  EditVM.swift
//  HungPhamV
//
//  Created by Hung Pham V. on 2/25/21.
//

import Foundation
import Combine

final class EditVM {

    var publisher: PassthroughSubject = PassthroughSubject<UserInfo, Never>()

    var name: String = ""
    var address: String = ""
    var types: Type = .delegate
}
