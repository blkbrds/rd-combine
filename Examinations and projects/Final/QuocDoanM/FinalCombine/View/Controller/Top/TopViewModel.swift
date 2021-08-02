//
//  TopViewModel.swift
//  FinalCombine
//
//  Created by Quoc  Doan M. VN.Danang on 7/12/21.
//

import UIKit
import Combine

final class TopViewModel: ObservableObject {
    
    enum State {
        case initialize
        case error(message: String)
    }
    
    enum Action {
        case downloadImage(indexPath: IndexPath)
    }
    
    // Action
    let action = PassthroughSubject<Action, Never>()
    // State
    let state = CurrentValueSubject<State, Never>(.initialize)
    @Published var gameStores: [StoreResult] = []
    var stores: Set<AnyCancellable> = Set<AnyCancellable>()
    
    init() {
        // state
        state
            .sink { [weak self] state in
                self?.processState(state)
            }.store(in: &stores)
        
        // action
        action
            .sink { [weak self] action in
                self?.processAction(action)
            }.store(in: &stores)
    }
    
    private func processAction(_ action: Action) { }
    
    // process State
    private func processState(_ state: State) {
        switch state {
        case .initialize:
            print("initial")
        case .error(let message):
            print("HOME Error: ", message)
        }
    }
}

// MARK: - Tableview
extension TopViewModel {

    func numberOfRows(in section: Int) -> Int {
        return gameStores.count
    }
    
    func getCategoryCellVM(at indexPath: IndexPath) -> Any {
        let gameStore = gameStores[indexPath.row]
        return StoreCellViewModel(store: gameStore)
    }
}

// MARK: - APIs
extension TopViewModel {

    func getData() {
        API.Store.requestStores()
            .map { $0.results }
            .sink(receiveCompletion: { error in
                switch error {
                case .finished:
                    print("Finish get Data")
                case .failure(let error):
                    self.state.send(.error(message: error.localizedDescription))
                }
            }, receiveValue: { [weak self] result in
                self?.gameStores = result
            })
            .store(in: &stores)
    }
}
