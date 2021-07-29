//
//  TeamViewModel.swift
//  MVVMCombine
//
//  Created by Tam Nguyen K. T. [7] VN.Danang on 7/16/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import Foundation
import Combine

final class TeamViewModel: ViewModelType {

    enum Action {
        case fetchData
        case handleFilter
    }

    enum State {
        case initial
    }

    // MARK: - Properties
    @Published private(set) var apiResult: APIResult<[Team]> = .none
    var filter: [Team] = []
    var filterA: [Team] = []
    var searchText: CurrentValueSubject<String, Never> = .init("")
    private(set) var isLoading: CurrentValueSubject<Bool, Never> = .init(false)
    private(set) var subscriptions: Set<AnyCancellable> = []
    let action = PassthroughSubject<Action, Never>()
    let state = CurrentValueSubject<State, Never>(.initial)

    init() {
        action
            .sink { [weak self] action in
            self?.processAction(action: action)
        }
            .store(in: &subscriptions)

        state
            .sink { [weak self] state in
            self?.processState(state: state)
        }
            .store(in: &subscriptions)
    }

    // MARK: - Methods
    func getTeams() {
        isLoading.send(true)
        APIType.getListTeam()
            .transformToAPIResult()
            .handleEvents(receiveOutput: { [weak self] _ in
            guard let this = self else { return }
            this.isLoading.send(false)
        })
            .assign(to: \.apiResult, on: self)
            .store(in: &subscriptions)
    }

    private func processAction(action: Action) {
        switch action {
        case .fetchData:
            getTeams()
        case .handleFilter:
            handleFilter()
        }
    }

    private func processState(state: State) {
        switch state {
        case .initial:
            isLoading.send(false)
        }
    }

    func handleFilter() {
        searchText
            .sink { [weak self] value in
            self?.filter = self?.filterA
                .filter { $0.strAlternate.lowercased().contains(value.lowercased()) } ?? []
        }
            .store(in: &subscriptions)
    }
}
