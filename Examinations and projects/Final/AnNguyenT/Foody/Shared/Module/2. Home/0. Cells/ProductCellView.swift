//
//  Cell.swift
//  Foody
//
//  Created by MBA0283F on 5/5/21.
//

import SwiftUI

let scale: CGFloat =  kScreenSize.width / 375

struct ProductCellView: View {
    
    var product: Product = Product()
    var voteProduct: ((Int) -> Void)?
        
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 5) {
                SDImageView(url: product.imageUrls.first)
                    .clipShape(RoundedRectangle(cornerRadius: 0))
                    .frame(width: geometry.size.width, height: geometry.size.height * 2 / 3)
                    .clipped()
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(product.name)
                    
                    Text(product.restaurantName)
                        .foregroundColor(Color(#colorLiteral(red: 0.6078431373, green: 0.6078431373, blue: 0.6078431373, alpha: 1)))
                        .font(.subheadline)
                    
                    HStack(spacing: 5) {
                        ForEach(0..<5) { index in
                            Image(systemName: SFSymbols.starFill)
                                .resizable()
                                .frame(width: 15 * scale, height: 15 * scale)
                                .foregroundColor(index < product.voteCount ? .yellow: .gray)
                                .onTapGesture {
                                    voteProduct?(index)
                                }
                        }
                        
                        Spacer(minLength: 0)
                        
                        HStack(spacing: 0) {
                            Text("\(product.price / 1000) ")
                                .bold()
                                .foregroundColor(.blue)
                            
//                            Text(".000")
//                                .font(.caption2)
                            
                            Text("K")
                                .underline()
                        }
                    }
                    .padding(.bottom, 10)
                }
                .font(.body)
                .foregroundColor(Color(#colorLiteral(red: 0.1490196078, green: 0.1490196078, blue: 0.1568627451, alpha: 1)))
                .lineLimit(1)
                .padding(.horizontal, 10)
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: .gray, radius: 3, x: 0.0, y: 2)
        }
        .padding(.bottom, 15)
    }
}

//struct ProductCellView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProductCellView()
//    }
//}
