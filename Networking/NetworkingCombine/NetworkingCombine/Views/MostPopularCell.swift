//
//  MostPopularCell.swift
//  List-NavigationDemo
//
//  Created by MBA0059 on 3/6/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct MostPopularCell: View {
    
    var restaurant: Restaurant
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    Spacer(minLength: 11)
                    ForEach(restaurant.images, id: \.self) { image in
                        WebImage(url: URL(string:image), options: [.progressiveLoad, .delayPlaceholder])
                            .resizable()
                            .placeholder(.wifiExclamationmark)
                            .indicator(.progress)
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 149, height: 86)
                            .clipped()
                    }
                    Spacer(minLength: 11)
                }
            }
            VStack(alignment: .leading, spacing: 0) {
                Spacer(minLength: 12)
                Text(restaurant.name)
                    .bold()
                if !restaurant.categoryName.content.isEmpty {
                    Spacer(minLength: 6)
                    Text(restaurant.categoryName.content)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer(minLength: 8)
                HStack {
                    ForEach(0 ..< 4) { item in
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.subheadline)
                    }
                    Spacer()
                    
                    Text(restaurant.priceString.content)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .padding([.leading, .trailing], 11)
        }
        .padding([.bottom, .top], 11)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.1))
                .shadow(radius: 5)
        )
    }
}

struct MostPopularCell_Previews: PreviewProvider {
    static var previews: some View {
        MostPopularCell(restaurant: Restaurant(id: 1, name: "", time: 0, rating: nil, image: "", categoryName: ""))
            
    }
}

extension Image {
    static var wifiExclamationmark: Image {
        #if os(macOS)
        return Image("wifi.exclamationmark")
        .resizable()
        #else
        return Image(systemName: "wifi.exclamationmark")
        .resizable()
        #endif
    }
}

// MARK: - Unwrap string
extension Optional where Wrapped == String {

    var content: String {
        switch self {
        case .some(let value):
            return String(describing: value)
        case _:
            return ""
        }
    }
}
