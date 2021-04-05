//
//  ContentView.swift
//  Photos
//
//  Created by An Nguyễn on 4/1/21.
//

import SwiftUI

struct PhotosView: View {
    @ObservedObject private var viewModel = PhotosViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.images, id: \.self) { image in
                    NavigationLink(
                        destination: Image(uiImage: image)
                                        .resizable()
                                        .frame(width: 300, height: 300)
                                        .navigationTitle(Text("Details")),
                        label: {
                            HStack {
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                Text("OKKKK")
                            }
                        }
                    )
                }
            }
            .navigationTitle(Text("Photos"))
        }
        .onAppear(perform: {
            viewModel.getPhotos()
        })
    }
}

struct PhotosView_Previews: PreviewProvider {
    static var previews: some View {
        PhotosView()
    }
}
