//
//  AppDelegate.swift
//  ExChapter8
//
//  Created by MBA0225 on 4/4/21.
//

import Foundation
import Combine
import UIKit

final class ViewModel {
    // MARK: - enum
    enum State {
        case initial
        case fetched
        case failed(Error)
    }

    enum Action {
        case fetchData
        case clear
    }
    
    let action = PassthroughSubject<Action, Never>()
    let state = CurrentValueSubject<State, Never>(.initial)

    var subscriptions = Set<AnyCancellable>()
    let images = CurrentValueSubject<[UIImage], Never>([])

    // MARK: - Init
    init() {
        state
            .sink { [weak self] in
                self?.processState($0)
            }
            .store(in: &subscriptions)
        action
            .sink { [weak self] action in
                self?.processAction(action)
            }
            .store(in: &subscriptions)
    }

    // MARK: - Function
    private func getImage() -> [UIImage] {
        var images: [UIImage] = []
        for index in 1...4 {
            if let imageItem = UIImage(named: "img-" + String(index)) {
                images.append(imageItem)
            }
        }
        return images
    }

    private func processAction(_ action: Action) {
        switch action {
        case .fetchData:
            images.send(getImage())
        case .clear:
            images.send([])
        }
    }

    private func processState(_ state: State) {
        switch state {
        case .initial:
            break
        case .fetched:
            break
        case .failed:
           break
        }
    }
}
