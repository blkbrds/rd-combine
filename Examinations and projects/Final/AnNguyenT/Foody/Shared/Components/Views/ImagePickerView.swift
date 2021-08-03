//
//  SwiftUIView.swift
//  Foody
//
//  Created by MBA0283F on 4/7/21.
//

import SwiftUI
import ImagePicker
import WaterfallGrid

struct ImagePickerView: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) private var presentationMode
    @Binding var images: [UIImage]
    var isUpdatingInfo: Bool
    
    init(_ images: Binding<[UIImage]> = .constant([]), isUpdatingInfo: Bool = false) {
        self.isUpdatingInfo = isUpdatingInfo
        self._images = images
    }
    
    func makeUIViewController(context: Context) -> some ImagePickerController {
        let configuration = Configuration()
        configuration.noImagesFont = .boldSystemFont(ofSize: 17)
        configuration.doneButton = .boldSystemFont(ofSize: 17)
        configuration.doneButtonTitle = "Done"
        configuration.noImagesTitle = "Sorry! There are no images here!"
        configuration.recordLocation = false
        let imagePicker = ImagePickerController(configuration: configuration)
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, ImagePickerDelegate {
        var parent: ImagePickerView
        
        init(_ imagePickerView: ImagePickerView) {
            self.parent = imagePickerView
        }
        
        func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
            if parent.isUpdatingInfo, !images.isEmpty {
                dismiss(with: images)
            }
            dismiss(with: images)
        }
        
        func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
            dismiss()
        }
        
        func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
            if parent.isUpdatingInfo, !images.isEmpty {
                dismiss(with: images)
            }
            dismiss(with: images)
        }
        
        func dismiss(with images: [UIImage] = []) {
            if !images.isEmpty {
                parent.images = images
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct ImagePickerViewDemo: View {
    @State var isPresented = false
    @State var images: [UIImage] = []
    
    var body: some View {
        ZStack {
            WaterfallGrid(images, id: \.self, content: { image in
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            })
            Text("Hiiii")
                .onTapGesture {
                    isPresented = true
                }
                .fullScreenCover(isPresented: $isPresented, content: {
                    ImagePickerView($images)
                        .onDisappear(perform: {
                            print("AAA", images.count)
                        })
                })
        }
        .padding()
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        ImagePickerViewDemo()
    }
}
