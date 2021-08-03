//
//  UpdateInfoViewModel.swift
//  Foody
//
//  Created by MBA0283F on 5/23/21.
//

import SwiftUI

final class UpdateInfoViewModel: ViewModel, ObservableObject {
    @Published var username: String = ""
    @Published var address: String = ""
    @Published var description: String = ""
    @Published var age: String = ""
    @Published var images: [UIImage] = []
    @Published var isUpdated: Bool = false
    @Published var isMale: Bool = false
    
    var inValidInfo: Bool {
        username.isEmpty || address.isEmpty || age.isEmpty
    }
    
    var user: User {
        Session.shared.user ?? User()
    }
    
    var restaurant: Restaurant {
        Session.shared.restaurant ?? Restaurant()
    }
    
    override init() {
        super.init()
        username = user.username
        address = user.address
        age = user.age.string
        isMale = user.gender
        address = user.address
                
        DispatchQueue.global().async {
            let images = [self.user.imageProfile]
                .compactMap({ URL(string: $0) })
                .compactMap({ try? Data(contentsOf: $0) })
                .compactMap({ UIImage(data: $0)})
            DispatchQueue.main.async {
                self.images = images
            }
        }
        
        description = restaurant.descriptions
    }
    
    func updateProfile() {
        guard let data = images.first?.pngData() else {
            self.error = .invalidInputData
            return
        }
        isLoading = true
        FirebaseTask.uploadFile(data: data, name: user.imageProfile.url?.lastPathComponent ?? "")
            .sink { (completion) in
                if case .failure(let error) = completion {
                    self.isLoading = false
                    self.error = error
                }
            } receiveValue: { (url) in
                self.updateInfo(profileUrl: url.absoluteString)
            }
            .store(in: &subscriptions)
    }
    
    private func updateInfo(profileUrl: String) {
        var params: Parameters = [
            "username"  : username,
            "address"   : address,
            "gender"    : isMale,
            "age"       : Int(age) ?? 0,
            "imageProfile": profileUrl
        ]
        if !description.isEmpty {
            params["descriptions"] = description
        }
        
        isLoading = true
        AccountService.updateInfo(params)
            .sink { (completion) in
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.error = error
                }
            } receiveValue: { (res) in
                Session.shared.user = res.user
                Session.shared.restaurant = res.restaurant
                self.isUpdated = true
            }
            .store(in: &subscriptions)
    }
}
