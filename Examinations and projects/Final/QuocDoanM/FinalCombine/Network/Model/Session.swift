//
//  Session.swift
//  FinalCombine
//
//  Created by Quoc  Doan M. VN.Danang on 8/2/21.
//

import Foundation

final class Session {
    
    public static var shared: Session {
        let session = Session()
        return session
    }
    
    private init() { }
    
    var users: [UserResponse] {
        get {
            if let data = ud.data(forKey: App.userResponse) {
                do {
                    // Create JSON Decoder
                    let decoder = JSONDecoder()
                    
                    // Decode Note
                    let users = try decoder.decode([UserResponse].self, from: data)
                    return users
                } catch {
                    print("Unable to Decode Note (\(error))")
                }
            }
            return []
        }
        set {
            do {
                let encoder = JSONEncoder()
                // Encode Data
                let data = try encoder.encode(newValue)
                
                // Write/Set Data
                UserDefaults.standard.set(data, forKey: App.userResponse)
            }
            catch {
                print("Unable to Encode Note (\(error))")
            }
        }
    }
}
