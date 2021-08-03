//
//  UserInfomation.swift
//  Foody
//
//  Created by An Nguyễn on 01/05/2021.
//

import Foundation

protocol UserInfomation {
    var _id: String { get set }
    
    var username: String { get set }
    
    var imageProfile: String { get set }
    
    var email: String { get set }
        
    var phoneNumber: String { get set }
    
    var address: String { set get }
    
    var gender: Bool { set get }
    
    var status: String { set get }
    
    var type: String { set get }
    
    var age: Int { set get }
}
