//
//  DrinkCellView.swift
//  NetworkingCombine
//
//  Created by MBA0283F on 4/12/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct DrinkCellView: View {
    var drink: Cocktail
    
    var body: some View {
        HStack(alignment: .top) {
            AnimatedImage(url: URL(string: drink.imageURL), options: [.progressiveLoad, .delayPlaceholder])
                .resizable()
                .placeholder(UIImage(named: "default-thumbnail"))
                .indicator(.activity)
                .transition(.fade(duration: 0.5))
                .aspectRatio(contentMode: .fill)
                .frame(width: 90, height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment: .leading,spacing: 6) {
                Text(drink.nameTitle)
                    .bold()
                    .lineLimit(1)
                
                HStack {
                    ForEach(0..<5) { index in
                        Image(systemName: "star.fill")
                            .resizable()
                            .frame(width: 15, height: 15)
                            .foregroundColor(index <= drink.voteCount ? .yellow: .gray)
                    }
                }
                .padding(.bottom, 20)
                
                Text(drink.instructions)
                    .font(.system(size: 11, weight: .light, design: .default))
                    .lineLimit(3)
            }
        }
    }
}

