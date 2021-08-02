//
//  AuthManager.swift
//  TheMovieCombineApp
//
//  Created by Toan Nguyen D. [4] VN.Danang on 27/07/2021.
//

import Foundation
import Combine

enum StatusResponseAPI {
    case success
    case failure(code: Int)
}

final class API {
    static var subscriptions = Set<AnyCancellable>()

    struct Path {
        static let baseImage = "http://image.tmdb.org/t/p/w185"
        static let apiKey: String = "fa616ceccd5c5667704f9a88dd9a51a1"
        static private let base: String = "https://api.themoviedb.org/3/"
    }

    struct Search {}
    struct Authentication {}
    struct Login {}
    struct Detail {}
}

extension API.Path {

    struct Search {
        static var key: String = "" {
            didSet {
                path = "\(base)search/movie?api_key=\(apiKey)&query=\(key)&page=\(page)"
            }
        }
        static var page: Int = 1 {
            didSet {
                path = "\(base)search/movie?api_key=\(apiKey)&query=\(key)&page=\(page)"
            }
        }
        static var path = "\(base)search/movie?api_key=\(apiKey)&query=\(key)&page=\(page)"
    }

    struct Authentication {
        static let pathRequestToken = "\(base)authentication/token/new?api_key=\(apiKey)"
        static let pathAllowAuth = "\(base)authenticate/\(AuthManager.shared.requestToken)/allow"
        static let pathCreateSessionId = "\(base)authentication/session/new?api_key=\(apiKey)&request_token=\(AuthManager.shared.requestToken)"
    }

    struct Login {
        static let path = "\(base)authentication/token/validate_with_login?api_key=\(API.Path.apiKey)"
    }

    struct CastOfMovie {
        static var idMovie: Int = 0 {
            didSet {
                path = "\(base)movie/\(idMovie)/credits?api_key=fa616ceccd5c5667704f9a88dd9a51a1&language=en-US"
            }
        }
        static var path = "\(base)movie/\(idMovie)/credits?api_key=fa616ceccd5c5667704f9a88dd9a51a1&language=en-US"
    }
}
