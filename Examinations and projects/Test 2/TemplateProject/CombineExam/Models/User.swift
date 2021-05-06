//
//  User.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import Foundation

struct User: Hashable {
    var id: String = UUID().uuidString
    var name: String
    var address: String
    var password: String = "12345678"
    var image: String? = Dummy.images.shuffled().first
}

struct Dummy {
    static let images: [String] = {
        ["https://i.pinimg.com/564x/7f/e0/3e/7fe03e29bf34dca114b4c22f11513a5b.jpg",
        "https://i.pinimg.com/236x/44/f0/41/44f0411f3e926c3bbeeb09aec7babdc2.jpg",
        "https://i.pinimg.com/236x/d9/71/38/d9713847241905d51f99fb480db5a772.jpg",
        "https://i.pinimg.com/236x/fe/58/8d/fe588ddceb153edf09054f6a2657f9dc.jpg",
        "https://i.pinimg.com/236x/8f/e2/70/8fe270b947ac40afc825aa22019c8ad0.jpg",
        "https://i.pinimg.com/236x/dd/eb/ba/ddebba065a4d782a9580fdf38732d0ee.jpg",
        "https://i.pinimg.com/564x/30/a7/fb/30a7fb40ea84b591d65e5ec8e123e302.jpg"]
    }()
}
