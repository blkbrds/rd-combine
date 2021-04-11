//
//  Restaurant.swift
//  List-NavigationDemo
//
//  Created by MBA0321 on 3/5/21.
//

import Foundation

struct Restaurant: Identifiable, Codable, Hashable {
    var id: Int
    var name: String
    var time: Double
    var rating: Int?
    var image: String?
    var priceString: String? = "$\(Int.random(in: 5...50)).00"
    var categoryName: String?
    var images: [String] = []
    
    enum CodingKeys: String, CodingKey {
        case id = "list_id"
        case name = "subject"
        case time = "list_time"
        case rating = "number_of_images"
        case image
//        case priceString = "price_string"
        case categoryName = "category_name"
    }
    
    init(id: Int, name: String, time: Double, rating: Int?, image: String?, categoryName: String?) {
        self.id = id
        self.name = name
        self.time = time
        self.rating = rating
        self.image = image
        self.categoryName = categoryName
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        time = try container.decode(Double.self, forKey: .time)
        rating = try? container.decode(Int.self, forKey: .rating)
        image = try? container.decode(String.self, forKey: .image)
        categoryName = try? container.decode(String.self, forKey: .categoryName)
        setupImages()
     }
    
    mutating func setupImages() {
        if image.content.isEmpty {
            images = Array(Dummy.images.shuffled().prefix(4))
        } else {
            images = [image.content] + Array(Dummy.images.shuffled().prefix(4))
        }
    }
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
