//
//  MusicListViewModel.swift
//  FinalProject_Combine
//
//  Created by An Nguyen Q. VN.Danang on 7/7/21.
//

import Foundation
import Combine

enum MusicCells {
    case music
    case loadmore
}

final class MusicListViewModel {
    // MARK: - Properties
    var musicsList: [Music] = []
    var allMusicsList: [Music] = []
    private var api = ApiManager()
    private var subscriptions = Set<AnyCancellable>()
    var musicCells: [MusicCells] = []
    @Published var limit: Int = 10
    var isSearch: Bool = false
    
    
    // MARK: - Private funcs
    func getMusicTableViewCellModel(_ index: Int) -> MusicTableViewCellModel {
        let music = musicsList[index]
        let viewModel = MusicTableViewCellModel(name: music.name,
                                                artistName: music.artistName,
                                                urlImage: music.artworkUrl100)
        return viewModel
    }
    
    func numberOfRowInSection() -> Int {
        var count: Int = 0
        musicCells.removeAll()
        count = musicsList.count == 0 ? 0 : isSearch ? musicsList.count : musicsList.count + 1
        if musicsList.count != 0 {
            for _ in 0..<musicsList.count {
                musicCells.append(.music)
            }
            if !isSearch {
                musicCells.append(.loadmore)
            }
        }
        return count
    }
    
    func getMusicList(_ limit: Int) -> Future<Void, APIError> {
            return Future { [weak self] resolve in
                guard let this = self else { return resolve(.failure(APIError.unknown)) }
                this.api.getMusicList(limit: limit)
                    .receive(on: DispatchQueue.main)
                    .sink(receiveCompletion: { completion in
                        switch completion {
                        case .finished: break
                        case .failure(let error):
                            resolve(.failure(error))
                        }
                    }, receiveValue: { result in
                        this.musicsList = result.feed.results
                        this.allMusicsList = result.feed.results
                        resolve(.success(()))
                    })
                    .store(in: &this.subscriptions)
            }
        }
}
