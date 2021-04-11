//
//  TrendingCell.swift
//  List-NavigationDemo
//
//  Created by MBA0059 on 3/6/21.
//

import SwiftUI
import SDWebImageSwiftUI
import Combine

struct TrendingCell: View {

    @State var index: Int = 0
    @StateObject var viewModel: TrendingCellViewModel
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        return VStack(alignment: .leading, spacing: 0) {
            PagerView(index: $index, pages: viewModel.restaurant.images.map { image in
                WebImage(url: URL(string:image), options: [.progressiveLoad, .delayPlaceholder])
                    .resizable()
                    .placeholder(.wifiExclamationmark)
                    .indicator(.progress)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250, height: 129)
                    .clipped()
            })
            .background(Color.black)
            .frame(width: 250, height: 129)
            .clipped()
            
            Text(viewModel.restaurant.name)
                .bold()
                .padding([.top, .leading, .trailing], /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                .padding(.bottom, 3)
                .lineLimit(1)
            
            Text(viewModel.restaurant.categoryName.content)
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding([.leading, .trailing], /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            
            HStack {
                ForEach(0 ..< 4) { item in
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.subheadline)
                }
                Spacer()
                
                Text(viewModel.restaurant.priceString.content)
                    .font(.subheadline)
                    .bold()
            }
            .padding(.all, 10)
            
        }
        .onReceive(timer, perform: { _ in
            withAnimation {
                if self.index + 1 >= viewModel.restaurant.images.count {
                    self.index = 0
                } else {
                    self.index += 1
                }
            }
        })
        .frame(width: 250)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.1))
                .shadow(radius: 5)
        )
    }
}

struct TrendingCell_Previews: PreviewProvider {
    static var previews: some View {
        TrendingCell(viewModel: TrendingCellViewModel(item: Restaurant(id: 1, name: "", time: 0, rating: nil, image: "", categoryName: "")))
    }
}
