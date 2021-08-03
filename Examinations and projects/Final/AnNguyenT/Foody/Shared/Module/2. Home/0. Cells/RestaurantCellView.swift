//
//  RestaurantView.swift
//  Foody
//
//  Created by MBA0283F on 5/5/21.
//

import SwiftUI

struct RestaurantCellView: View {
    var restaurant: Restaurant = Restaurant()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 13) {
                    if restaurant.images.isEmpty {
                        Image(nil)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 155 * scale, height: 90 * scale)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                    } else {
                        ForEach(restaurant.images, id: \.self) { url in
                            SDImageView(url: url)
                                .frame(width: 155 * scale, height: 90 * scale)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                }
                .padding([.horizontal, .top])
            }
            
            Text(restaurant.name)
                .foregroundColor(Color(#colorLiteral(red: 0.1490196078, green: 0.1490196078, blue: 0.1568627451, alpha: 1)))
                .font(.title3)
                .padding(.horizontal)
            
            Text(restaurant.address)
                .padding(.horizontal)
            
            HStack(spacing: 5) {
                ForEach(0..<5) { index in
                    Image(systemName: SFSymbols.starFill)
                        .resizable()
                        .frame(width: 16 * scale, height: 16 * scale)
                        .foregroundColor(index < restaurant.vote ? .yellow: .gray)
                }
                
                Spacer(minLength: 0)
                
                Text(restaurant.openTime)
            }
            .padding(.top, 5)
            .padding([.horizontal, .bottom])
        }
        .font(.body)
        .lineLimit(1)
        .foregroundColor(Color(#colorLiteral(red: 0.6078431373, green: 0.6078431373, blue: 0.6078431373, alpha: 1)))
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: .gray, radius: 5, x: 0.0, y: 2)
    }
}

//struct RestaurantCellView_Previews: PreviewProvider {
//    static var previews: some View {
//        RestaurantCellView()
//    }
//}
