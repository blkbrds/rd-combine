//
//  ApiManager.swift
//  Foody
//
//  Created by MBA0283F on 4/5/21.
//

import Moya

typealias Parameters = [String: Any]
typealias JSObject = [String: Any]
typealias JSArray = [JSObject]

enum VerifyAction: String {
    case register, forgot
}

enum Router {
    
    //Customer
    case requestOrder(Parameters), cancelOrder(String)
    case popularRestaurants(Int), trendingProducts(Int), popularProducts(String)
    case getRestaurant(String)
    case comment(String, Parameters)
    case voteRestaurant(String, Int)
    case voteProduct(String, Int)
    case getFavorites, newFavorite(Parameters), deleteFavorite(String)
    
    // Common
    case refreshToken
    case getProduct(String)
    case getComments(String)
    case getOrders
    case getNotifications, readNotification(id: String) // SWIP
    
    // Restaurant
    case getKeywords(String)
    case getProducts(Int), newProduct(Parameters), deleteProduct(String), updateProduct(Parameters)
    case searchProducts(productName: String, page: Int)
    case getChartInfo(Int) //month
    case verifyOrder(Parameters)
    case blacklist(Parameters)
    case getBlacklist
    
    case updatePassword(String, String), updateInfo(Parameters)
    case verifyEmail(email: String, VerifyAction)
    case login(String, String)
    case register(Parameters)
    case me
    case userInfo(String)
}

extension Router: TargetType {
    var version: String {
        return "v1"
    }
    
    var baseURL: URL {
        var baseURLString: String = "https://foody-app-final.herokuapp.com" / version // "https://flask-fast-food.herokuapp.com" / version
        #if DEBUG
//        baseURLString = "http://127.0.0.1:5000" / version
        #endif
        guard let url = URL(string: baseURLString) else {
            fatalError("baseURL could not be configured.")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .refreshToken:
            return "account/token/refresh"
        
        case .blacklist, .getBlacklist:
            return "blacklist"
        case .getComments:
            return "/product/comments"
        case .comment:
            return "/product/comment"
        case .getFavorites, .deleteFavorite, .newFavorite:
            return "/products/favorite"
        
        case .popularProducts:
                return "/restaurant/products/popular"
        case .popularRestaurants:
            return "/restaurants/popular"
        case .getRestaurant, .voteRestaurant:
            return "/restaurant"
        case .cancelOrder, .requestOrder:
            return "/order"
            
        case .updateInfo, .me, .userInfo:
            return "/account"
        case .updatePassword:
            return "/account/password/forgot"
        case .verifyEmail:
            return "/account/verify/email"
        case .register:
            return "/register"
        case .login:
            return "/login"
            
        case .getProducts, .trendingProducts: // restaurant products -  trending products
            return "/products"
        case .getProduct, .newProduct, .deleteProduct, .updateProduct, .voteProduct:
            return "/product"
            
        case .searchProducts:
            return "/search/products"
        case .getKeywords:
            return "/keywords"
            
        case .getChartInfo:
            return "/charts"
        
        case .getOrders:
            return "/orders"
        case .verifyOrder:
            return "/order"
            
        case .getNotifications:
            return "/notifications"
        case .readNotification:
            return "/notification"
        }
    }
    
    var method: Method {
        switch self {
        case .blacklist, .refreshToken, .login, .register, .verifyEmail, .newFavorite, .newProduct, .comment, .updateInfo, .requestOrder:
            return .post
        case .updateProduct, .updatePassword, .verifyOrder, .readNotification, .voteProduct, .voteRestaurant:
            return .put
        case .deleteFavorite, .deleteProduct, .cancelOrder:
            return .delete
        default:
            return .get
        }
    }
    
    var sampleData: Data {
        Data()
    }
    
    var task: Task {
        switch self {
        case .voteProduct(let id, let vote), .voteRestaurant(let id, let vote):
            return .requestParameters(parameters: ["id": id, "voteCount": vote], encoding: JSONEncoding.default)
        case .newFavorite(let params), .newProduct(let params), .updateProduct(let params):
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        
        case .comment(let id, let params):
            var tempParams = params
            tempParams["productId"] = id
            return .requestParameters(parameters: tempParams, encoding: JSONEncoding.default)
        
        case .deleteFavorite(let id), .deleteProduct(let id), .readNotification(let id), .cancelOrder(let id):
            return .requestParameters(parameters: ["id": id], encoding: JSONEncoding.default)
        
        case .getProduct(let id), .getComments(let id), .getRestaurant(let id), .popularProducts(let id), .userInfo(let id):
            return .requestParameters(parameters: ["id": id], encoding: URLEncoding.queryString)
        case .searchProducts(let productName, let page):
            return .requestParameters(parameters: ["name": productName, "page": page], encoding: URLEncoding.queryString)
            
        case .updatePassword(let email, let password):
            return .requestParameters(parameters: ["email": email, "password": password], encoding: JSONEncoding.default)
        case .verifyEmail(let email, let action):
            return .requestParameters(parameters: ["email": email, "action": action.rawValue], encoding: JSONEncoding.default)
        case .blacklist(let params), .register(let params), .updateInfo(let params), .requestOrder(let params), .verifyOrder(let params):
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .login(let email, let password):
            return .requestParameters(parameters: ["email": email, "password": password], encoding: JSONEncoding.default)
        
        case .getProducts(let page), .popularRestaurants(let page), .trendingProducts(let page):
            return .requestParameters(parameters: ["page": page], encoding: URLEncoding.queryString)
            
        case .getChartInfo(let month):
            return .requestParameters(parameters: ["month": month], encoding: URLEncoding.queryString)
        
        case .getFavorites, .getOrders, .getNotifications, .me, .getBlacklist:
            return .requestParameters(parameters: [:], encoding: URLEncoding.queryString)
        
        case .refreshToken:
            return .requestParameters(parameters: [:], encoding: JSONEncoding.default)
        
        case .getKeywords(let text):
            return .requestParameters(parameters: ["text": text], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        var headers = ["Content-type": "application/json"]
        if let token = Session.shared.accessToken {
            headers["Authorization"] = token
            print("DEBUG - Authorization: ", token)
        }
        return headers
    }
    
}



