//
//  ResponseSerializer.swift
//  CombineFinalProject
//
//  Created by Tan Huynh T. VN.Danang on 7/22/21.
//

import Foundation
import SwiftUtils
import Alamofire

extension DataRequest {

    @discardableResult
    func dataRequestResponse() -> DataResponsePublisher<Data> {
        responseData { (response) in
            let result = response.result
            switch result {
            case .success: break
            case .failure(let error):
                if let code = error.responseCode, let status = HTTPStatus(code: code) {
                    switch status {
                    case .unauthorized:
                        print("Get error unauthorized")
                    case .serviceUnavailable:
                        print("Get error serviceUnavailable")
                    case .noResponse:
                        print("Get error noResponse")
                    case .upgradeRequired:
                        print("Get error upgradeRequired")
                    case .gone:
                        print("Get error gone")
                    case .notAcceptable:
                        print("Get error notAcceptable")
                    default: break
                    }
                }
            }
        }.publishData()
        
//        return responseJSON(queue: .main) { (response) in
//            let result = response.result
//            switch result {
//            case .success: break
//            case .failure(let error):
//                if let code = error.responseCode, let status = HTTPStatus(code: code) {
//                    switch status {
//                    case .unauthorized:
//                        print("Get error unauthorized")
//                    case .serviceUnavailable:
//                        print("Get error serviceUnavailable")
//                    case .noResponse:
//                        print("Get error noResponse")
//                    case .upgradeRequired:
//                        print("Get error upgradeRequired")
//                    case .gone:
//                        print("Get error gone")
//                    case .notAcceptable:
//                        print("Get error notAcceptable")
//                    default: break
//                    }
//                }
//            }
//        }
    }
}
