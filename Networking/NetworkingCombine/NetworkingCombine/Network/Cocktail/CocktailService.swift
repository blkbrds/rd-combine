//
//  CocktailService.swift
//  NetworkingCombine
//
//  Created by MBA0253P on 4/14/21.
//

import Foundation

enum CocktailService {
    case getCocktail(name: String)
}

extension CocktailService: TargetType {
    var baseURL: URL {
        return  URL(string: "https://www.thecocktaildb.com")!
    }

    var path: String {
        switch self {
        case .getCocktail:
            return "/api/json/v1/1/search.php?"
        }
    }
    
    var sampleData: Data {
        Data.init(forResouce: "Posts", ofType: "json")
    }

    var method: HTTPMethod {
        switch self {
        case .getCocktail:
            return .get
        }
    }

    var parameters: Parameters {
        switch self {
        case .getCocktail(let name):
            return ["s":"\(name)"]
        }
    }

    var headers: [String: String]? {
        switch self {
        case .getCocktail:
            return nil
        }
    }
}

extension Data {

    init(forResouce name: String?, ofType ext: String?) {
        @objc class TestClass: NSObject { }
        let bundle = Bundle.init(for: TestClass.self)
        guard let path = bundle.path(forResource: name, ofType: ext),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            fatalError("fatalError")
        }
        self = data
    }
}
