//
//  SDImageView.swift
//  Foody
//
//  Created by An Nguyễn on 01/06/2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct SDImageView: View {
    var url: String?
    var isProfile: Bool = false
    
    var body: some View {
        WebImage(url: URL(string: url ?? ""), options: [])
            .resizable()
            .placeholder(Image(isProfile ? "no-user": "default-thumbnail"))
            .indicator(.activity)
            .transition(.fade(duration: 0.5))
            .aspectRatio(contentMode: .fill)
//            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct SDImageView_Previews: PreviewProvider {
    static var previews: some View {
        SDImageView(url: "https://travelservices-lesvos.com/wp-content/uploads/2020/06/banh-trang-kep-tai-da-nang-9.jpg")
    }
}
