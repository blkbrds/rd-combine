//
//  SearchResultViewModel.swift
//  CombineFinalProject
//
//  Created by Tan Huynh T. VN.Danang on 7/24/21.
//

import Foundation
import Combine
import Alamofire

final class SearchResultViewModel {

    var keyword: String = ""
    var videos: [Video] = []
    var subscriptions = Set<AnyCancellable>()
    var nextPageToken: String?

    init(keyword: String) {
        self.keyword = keyword
    }

    func numberOfRows(in section: Int) -> Int {
        return videos.count
    }

    func viewModelForCell(at indexPath: IndexPath) -> VideoTableCellModel {
        let video = videos[indexPath.row]
        return VideoTableCellModel(video: video)
    }

    func isNeedLoadMore(at indexPath: IndexPath) -> Bool {
        return indexPath.row == videos.count - 2
    }
}

// MARK: - APIs
extension SearchResultViewModel {

    func searchVideos(keyword: String) -> AnyPublisher<([Video], String), AFError> {
        var params: [String: String] = [:]
        params["part"] = "snippet"
        params["q"] = keyword
        params["maxResults"] = "10"
        params["regionCode"] = "VN"
        if let pageToken = nextPageToken {
            params["pageToken"] = "\(pageToken)"
        }

        let publisher = SearchService.searchVideos(params: params)
        publisher.sink { (completion) in
            print(completion)
        } receiveValue: { (videos, nextPageToken) in
            self.nextPageToken = nextPageToken
            self.videos.append(contentsOf: videos)
        }.store(in: &subscriptions)
        return publisher
    }
}
