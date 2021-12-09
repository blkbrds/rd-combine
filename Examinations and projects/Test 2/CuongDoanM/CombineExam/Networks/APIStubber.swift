//
//  APIStubber.swift
//  CombineExam
//
//  Created by Cuong Doan M. on 4/28/21.
//

import Foundation

extension APIProvider {
    
    final class func defaultStubClosure(for target: Target) -> APIOutput {
        return (target.sampleData, defaultStubResponse(for: target))
    }
    
    fileprivate class func defaultStubResponse(for target: Target) -> URLResponse {
        guard let url: URL = URL(string: target.baseURLString + target.path) else {
            fatalError("Invalid URL")
        }
        return HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: target.headers).unwrapped(or: HTTPURLResponse())
    }
}

let stubClosure = { (target: APITarget) -> APIOutput in
    var data: Data = target.sampleData
    let response: URLResponse = APIProvider.defaultStubResponse(for: target)
    return (data, response)
}
