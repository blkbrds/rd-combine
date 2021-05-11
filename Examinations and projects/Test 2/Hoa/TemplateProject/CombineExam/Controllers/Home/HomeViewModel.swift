//
//  HomeViewModel.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import Foundation
import Combine
final class HomeViewModel {

    let usersSort = LocalDatabase.users.sorted(by: {$0.name < $1.name})
    var users = [User]()
    lazy var rangeIn: Range<Int> = Range(0...usersSort.count)
    var subcriptions = Set<AnyCancellable>()

    init() {
        users = usersSort
    }

    func numberOfItems () -> Int {
        return users.count
    }

    func itemOfCell(in indexPath: IndexPath) -> HomeCellViewModel {
        let user: User = users[indexPath.row]
        let vm = HomeCellViewModel(user: user)
        return vm
    }

    func search(text: String, range: Range<Int>) {
        if text.isEmpty {
            users = usersSort
        } else {
            if text.count != 0 {
                users = []
            }
            usersSort.publisher.output(in: range).sink { (user) in
                if user.name.prefix(text.count) == text {
                    self.users.append(user)
                }
            }.store(in: &subcriptions)
            guard let start = users.first, let end = users.last else {
                return
            }
            let firstIndex = usersSort.firstIndex(of: start) ?? 0
            let lastIndex = usersSort.lastIndex(of: end) ?? usersSort.count
            rangeIn = Range(firstIndex...lastIndex)
        }
    }
}
