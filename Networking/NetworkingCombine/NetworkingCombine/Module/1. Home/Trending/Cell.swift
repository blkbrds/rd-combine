//
//  Cell.swift
//  List-NavigationDemo
//
//  Created by MBA0283F on 3/9/21.
//

import SwiftUI
import SDWebImageSwiftUI

private let scale: CGFloat =  UIScreen.main.bounds.width / 375

struct Cell: View {
    
    @State var voteCount: Int = Int.random(in: 1...5)
    var restaurant: Restaurant
    
    var body: some View {
        VStack(alignment: .leading) {
            GeometryReader { geometry in
                WebImage(url: URL(string: restaurant.image ?? ""), options: [.progressiveLoad, .delayPlaceholder])
                    .resizable()
                    .placeholder(.wifiExclamationmark)
                    .indicator(.progress)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
            }
            .frame(height: 129 * scale)
            
            Group {
                Text(restaurant.name)
                    .font(.system(size: 13))
                
                Text(restaurant.categoryName ?? "")
                    .foregroundColor(Color(#colorLiteral(red: 0.6078431373, green: 0.6078431373, blue: 0.6078431373, alpha: 1)))
                
                HStack(spacing: 2) {
                    ForEach(0..<5) { index in
                        Image(systemName: "star.fill")
                            .resizable()
                            .frame(width: 15 * scale, height: 15 * scale)
                            .foregroundColor(index <= voteCount ? .yellow: .gray)
                            .onTapGesture {
                                voteCount = index
                            }
                    }
                    Spacer(minLength: 0)
                    Text(restaurant.priceString ?? "0.00")
                        .foregroundColor(Color(#colorLiteral(red: 0.1490196078, green: 0.1490196078, blue: 0.1568627451, alpha: 1)))
                }
                .padding(.bottom, 10)
            }
            .lineLimit(1)
            .padding(.horizontal, 6)
        }
        .font(.system(size: 15, weight: .bold, design: .default))
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(radius: 10)
    }
}

//struct Cell_Previews: PreviewProvider {
//    static var previews: some View {
//        Cell(restaurant: Restaurant())
//            .frame(width: 164, height: 211, alignment: .center)
//    }
//}
