//
//  GifView.swift
//  Foody
//
//  Created by An Nguyễn on 06/05/2021.
//

import SwiftUI
import SwiftyGif

struct GifView: UIViewRepresentable {
    var gifName: String
    func makeUIView(context: Context) -> some UIImageView {
        if let gif = try? UIImage(gifName: "\(gifName).gif") {
            let imageView = UIImageView(gifImage: gif, loopCount: -1)
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleToFill
            return imageView
        }
        return UIImageView()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

struct GifView_Previews: PreviewProvider {
    static var previews: some View {
        GifView(gifName: "cart-preview")
            .frame(.init(width: 50, height: 50))
    }
}

