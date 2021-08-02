//
//  DetailVC.swift
//  FinalCombine
//
//  Created by Thinh Nguyen X. [2] VN.Danang on 7/20/21.
//

import UIKit
import AVKit

class DetailVC: UIViewController {

    // MARK: - Properties
    var viewModel: DetailViewModel!

    // MARK: - IBOutlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var playVideoView: UIView!

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }

    private func configUI() {
        titleLabel.text = viewModel.cook.name
        configPlayVideo()
    }

    private func configPlayVideo() {
        print(viewModel.cook.videoUrl ?? "")
        if let urlString = viewModel.cook.videoUrl, let videoURL = URL(string: urlString) {
            let player = AVPlayer(url: videoURL)
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = CGRect(origin: playVideoView.frame.origin,
                                       size: CGSize(width: UIScreen.main.bounds.width,
                                                    height: playVideoView.frame.height))
            self.playVideoView.layer.addSublayer(playerLayer)
            player.play()
        } else {
            let imageView = UIImageView()
            imageView.frame = playVideoView.bounds
            imageView.sd_setImage(with: URL(string: viewModel.cook.thumbnailUrl ?? ""),
                                  placeholderImage: UIImage(named: "bo_bit_tet.png"))
            playVideoView.addSubview(imageView)
            view.layoutIfNeeded()
        }
    }

    // MARK: - IBActions
    @IBAction private func backButtionTouchUpInSide(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
