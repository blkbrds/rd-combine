//
//  HomeViewModel.swift
//  FinalCombine
//
//  Created by Thinh Nguyen X. [2] VN.Danang on 7/19/21.
//

import Foundation
import Combine

final class HomeViewModel {

    @Published var searchKeyword: String = ""
    @Published var cooks: [Cook] = []
    @Published var isLoading = false
    let error: CurrentValueSubject<Error?, Never> = .init(nil)

    var stores: Set<AnyCancellable> = []

    init() {
        getCookings(type: .lists(""))
    }


    func getCookings(type: APITarget) {
        isLoading = true
        apiProvider.request(type)
            .receive(on: RunLoop.main)
            .map(\.data).print()
            .decode(type: APIResponse<Cook>.self, decoder: JSONDecoder())
            .sink(receiveCompletion: { [weak self] in
                guard let this = self else { return }
                if case .failure(let error) = $0 {
                    this.error.value = error
                    print("Error: ", error.localizedDescription)
                }
            }, receiveValue: { [weak self] value in
                guard let this = self else { return }
                this.cooks = value.results
                this.isLoading = false
                print(this.cooks)
            }).store(in: &stores)
    }

    func getApiSearch() {
        isLoading = true
        $searchKeyword.debounce(for: .seconds(0.2), scheduler: DispatchQueue.main)
            .share()
            .sink(receiveCompletion: { [weak self] completion in
                guard let this = self else { return }
                if case .failure(let error) = completion {
                    this.error.value = error
                }
            }, receiveValue: { [weak self] value in
                guard let this = self else { return }
                print("----KEYWORD----", this.searchKeyword)
                this.getCookings(type: .lists(this.searchKeyword))
            }).store(in: &stores)
    }
}
