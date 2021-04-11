//
//  PagerView.swift
//  List-NavigationDemo
//
//  Created by MBA0321 on 3/16/21.
//

import SwiftUI

struct PagerView<Content: View>: View {

    @Binding var index: Int

    // 1
    var pages: [Content]

    var body: some View {
        return GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(0..<pages.count) { index in
                        let page = pages[index]
                        page.frame(width: geometry.size.width, height: geometry.size.height)
                    }
                }
            }
            // 2
            .content.offset(x: -geometry.size.width * CGFloat(self.index))
        }
    }
}
