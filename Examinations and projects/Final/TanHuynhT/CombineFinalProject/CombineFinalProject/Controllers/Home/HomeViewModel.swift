//
//  HomeViewModel.swift
//  CombineFinalProject
//
//  Created by Tan Huynh T. VN.Danang on 7/17/21.
//

import Foundation
import Combine
import Alamofire

final class HomeViewModel: ViewModelType {

    private(set) var videos: CurrentValueSubject<[Video], Never> = .init([])
    var nextPageToken: String?
    // For searching
    private(set) var chanels: CurrentValueSubject<[VideoChannel], Never> = .init([])

    // APIResult
    @Published private(set) var videosApiResult: APIResult<([Video], String)> = .none
    @Published private(set) var channelsApiResult: APIResult<[VideoChannel]> = .none

    // ViewModelType
    private(set) var isLoading: CurrentValueSubject<Bool, Never> = .init(false)
    private(set) var subscriptions: Set<AnyCancellable> = []

    init() {
        // Videos
        $videosApiResult
            .handle(onSucess: { [weak self] videos, nextPageToken in
                guard let this = self else { return }
                this.nextPageToken = nextPageToken
                this.videos.send(this.videos.value + videos)
            })
            .store(in: &subscriptions)

        // Search channel
        $channelsApiResult
            .handle(onSucess: { [weak self] chanels in
                guard let this = self else { return }
                this.chanels.send(chanels)
            })
            .store(in: &subscriptions)
    }

    func viewModelForCell(at indexPath: IndexPath) -> VideoTableCellModel {
        let video = videos.value[indexPath.row]
        return VideoTableCellModel(video: video)
    }

    func viewModelForDetail(at indexPath: IndexPath) -> DetailViewModel {
        let video = videos.value[indexPath.row]
        return DetailViewModel(video: video)
    }

    func isNeedLoadMore(at indexPath: IndexPath) -> Bool {
        return indexPath.row == videos.value.count - 2
    }

    //For Searching
    func viewModelForCellSearchResult(at indexPath: IndexPath) -> KeySearchResultCellViewModel {
        let channel = chanels.value[indexPath.row]
        return KeySearchResultCellViewModel(keyword: channel.channelTitle)
    }

    func clearSearchResults() {
        chanels.value.removeAll()
    }
}

// MARK: - APIs
extension HomeViewModel {

    func getRecommendVideos() {
        var params: [String: String] = [:]
        params["part"] = "id, snippet, statistics"
        params["chart"] = "mostPopular"
        params["maxResults"] = "10"
        params["regionCode"] = "VN"
        if let pageToken = nextPageToken {
            params["pageToken"] = "\(pageToken)"
        }

        hud.show()
        HomeService.getRecommendVideos(params: params)
            .transformToAPIResult()
            .handleEvents(receiveOutput: { _ in
                hud.dismiss()
            })
            .assign(to: \.videosApiResult, on: self)
            .store(in: &subscriptions)
    }

    func searchChannels(keyword: String) {
        var params: [String: String] = [:]
        params["part"] = "snippet"
        params["q"] = keyword
        params["maxResults"] = "10"
        params["regionCode"] = "VN"
        params["type"] = "channel"

        hud.show()
        HomeService.getChannels(params: params)
            .transformToAPIResult()
            .handleEvents(receiveOutput: { _ in
                hud.dismiss()
            })
            .assign(to: \.channelsApiResult, on: self)
            .store(in: &subscriptions)
    }
}
