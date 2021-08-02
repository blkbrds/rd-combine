//
//  VideoDetailViewModel.swift
//  CombineFinalProject
//
//  Created by Tan Huynh T. VN.Danang on 7/25/21.
//

import Foundation
import Combine
import Alamofire

final class DetailViewModel: ViewModelType {

    var video: Video                                                               // For video info
    var relatedVideos: CurrentValueSubject<[Video], Never> = .init([])             // For realted videos
    var channel: CurrentValueSubject<Channel, Never> = .init(Channel())            // For channel info
    var nextPageToken: String?
    var isVideoPlaying: Bool = false

    // APIResult
    @Published private(set) var videosApiResult: APIResult<([Video], String)> = .none
    @Published private(set) var channelApiResult: APIResult<Channel> = .none

    // ViewModelType
    private(set) var isLoading: CurrentValueSubject<Bool, Never> = .init(false)
    private(set) var subscriptions: Set<AnyCancellable> = []

    init(video: Video) {
        self.video = video

        // Videos
        $videosApiResult
            .handle(onSucess: { [weak self] videos, nextPageToken in
                guard let this = self else { return }
                this.nextPageToken = nextPageToken
                this.relatedVideos.send(this.relatedVideos.value + videos)
            })
            .store(in: &subscriptions)

        // Channel
        $channelApiResult
            .handle(onSucess: { [weak self] chanel in
                guard let this = self else { return }
                this.channel.send(chanel)
            })
            .store(in: &subscriptions)
    }

    func viewModelForVideoInfo(at indexPath: IndexPath) -> VideoInfoCellViewModel {
        return VideoInfoCellViewModel(video: video)
    }

    func viewModelForChannelInfo(at indexPath: IndexPath) -> ChannelInfoCellViewModel {
        return ChannelInfoCellViewModel(channel: channel.value)
    }

    func viewModelForRelatedVideo(at indexPath: IndexPath) -> VideoTableCellModel {
        guard indexPath.row < relatedVideos.value.count else { return VideoTableCellModel(video: Video()) }
        let video = relatedVideos.value[indexPath.row]
        return VideoTableCellModel(video: video)
    }

    func isNeedLoadMore(at indexPath: IndexPath) -> Bool {
        return indexPath.row == relatedVideos.value.count - 2
    }

    func getUrlForPlaying() -> URL? {
//        let queryItems = [URLQueryItem(name: "key", value: "AIzaSyCnK3hpM2A-SzFVUsnUvcXkeP1H6DBP86o"),
//                          URLQueryItem(name: "v", value: "\(video.id)")]
//        guard var urlComps = URLComponents(string: "https://www.youtube.com/watch") else { return nil }
//        urlComps.queryItems = queryItems
//        return urlComps.url

        return URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")
    }
}

// MARK: - APIs
extension DetailViewModel {

    func getRelatedVideos() {
        var params: [String: String] = [:]
        params["part"] = "id, snippet"
        params["channelId"] = video.channelId
        params["maxResults"] = "5"
        if let pageToken = nextPageToken {
            params["pageToken"] = "\(pageToken)"
        }

        hud.show()
        DetailService.getRelatedVideos(params: params)
            .transformToAPIResult()
            .handleEvents(receiveOutput: { _ in
                hud.dismiss()
            })
            .assign(to: \.videosApiResult, on: self)
            .store(in: &subscriptions)
    }

    func getChannelInfo() {
        var params: [String: String] = [:]
        params["part"] = "id, snippet, statistics"
        params["id"] = video.channelId

        hud.show()
        DetailService.getChannelInfo(params: params)
            .transformToAPIResult()
            .handleEvents(receiveOutput: { _ in
                hud.dismiss()
            })
            .assign(to: \.channelApiResult, on: self)
            .store(in: &subscriptions)
    }
}
