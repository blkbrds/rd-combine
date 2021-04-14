//
//  ViewController.swift
//  EXCombineChapter8
//
//  Created by MBA0253P on 4/3/21.
//

import UIKit
import Combine

final class ViewController: UIViewController {
    @IBOutlet private var imageViews: [UIImageView]!
    
    var viewModel: ViewModel = ViewModel()
    var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindingToView()
        viewModel.action.send(.fetchData)
    }
    
    private func bindingToView() {
        for (index, image) in imageViews.enumerated() {
            viewModel.images
                .drop(while: { $0.isEmpty })
                .map({ $0[index] })
                .assign(to: \.image, on: image)
                .store(in: &subscriptions)
        }
    }
}
