//
//  CommentView.swift
//  Foody
//
//  Created by An Nguyễn on 2/28/21.
//

import SwiftUI

struct CommentView: View {
    var comment = Comment()
    var body: some View {
        HStack(alignment: .top) {
            SDImageView(url: comment.imageProfile, isProfile: true)
                .frame(width: 30, height: 30)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 7) {
                HStack(alignment: .firstTextBaseline) {
                    VStack(alignment: .leading) {
                        Text(comment.username)
                            .bold(size: 15)
                        Text(comment.time)
                            .regular(size: 12)
                            .foregroundColor(#colorLiteral(red: 0.6078431373, green: 0.6078431373, blue: 0.6078431373, alpha: 1).color)
                    }
                    Spacer()
                    VotesView(numberOfVotes: comment.voteCount ?? 0, size: 12)
                }
                
                Text(comment.content)
                    .font(.body)
                    .lineLimit(3)
            }
        }
    }
}

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentView()
    }
}
