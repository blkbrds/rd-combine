//
//  LoginService.swift
//  CombineFinalProject
//
//  Created by Tan Huynh T. VN.Danang on 7/25/21.
//

import Foundation
import Firebase
import Combine
import ObjectMapper

final class UserService {

    class func getAccountWith(email: String) -> DatabaseQuery {
        var ref: DatabaseReference!
        ref = Database.database(url: "https://combine-final-project-default-rtdb.asia-southeast1.firebasedatabase.app").reference(withPath: "response/user")
        let publisher = ref.queryOrdered(byChild: "email").queryEqual(toValue: email)
        return publisher
    }

    class func register(params: JSObject, id: String) -> DatabaseReference {
        var ref: DatabaseReference!
        ref = Database.database(url: "https://combine-final-project-default-rtdb.asia-southeast1.firebasedatabase.app").reference(withPath: "response/user")
        ref.child(id).setValue(params) { (error, refer) in
            ref = refer
        }
        return ref
    }
}
