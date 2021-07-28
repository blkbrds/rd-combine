//
//  MusicDetailViewController.swift
//  FinalProject_Combine
//
//  Created by An Nguyen Q. VN.Danang on 7/23/21.
//

import UIKit
import Combine

final class MusicDetailViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var artistLabel: UILabel!
    @IBOutlet private weak var linkButton: UIButton!
    
    // MARK: - Properties
    var viewModel = MusicDetailViewModel() {
        didSet {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.updateUI()
            }
        }
    }
    var subscriptions = Set<AnyCancellable>()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bindingCombine()
    }

    // MARK: - Private funcs
    private func bindingCombine() {
        linkButton.publisher(for: .touchUpInside)
            .sink { button in
                guard let text = button.titleLabel?.text, let url = URL(string: text) else { return }
                UIApplication.shared.open(url)
            }
            .store(in: &subscriptions)
    }
    private func updateUI() {
        guard let music = viewModel.music, let url = URL(string: music.artworkUrl100) else {
            return
        }
        
        imageView.load(url: url)
        nameLabel.text = music.name
        artistLabel.text = music.artistName
        linkButton.setTitle(music.url, for: .normal)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.linkButton.underline()
        }
    }
}
