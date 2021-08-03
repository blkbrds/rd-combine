//
//  VotesView.swift
//  Foody
//
//  Created by An Nguyễn on 2/28/21.
//

import SwiftUI

struct VotesView: View {
    var numberOfVotes: Int = 0
    var size: CGFloat = 12
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<5) { i in
                Image(systemName: SFSymbols.starFill)
                    .resizable()
                    .frame(width: size, height: size)
                    .foregroundColor(numberOfVotes > i ? .yellow: #colorLiteral(red: 0.6078431373, green: 0.6078431373, blue: 0.6078431373, alpha: 1).color)
            }
        }
    }
}

struct VotesView_Previews: PreviewProvider {
    static var previews: some View {
        VotesView()
    }
}
