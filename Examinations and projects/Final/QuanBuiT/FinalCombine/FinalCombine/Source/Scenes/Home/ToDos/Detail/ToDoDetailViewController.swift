//
//  ToDoDetailViewController.swift
//  FinalCombine
//
//  Created by Quan Bui T on 2021-07-23.
//  Copyright © 2021 Monstar-Lab Inc. All rights reserved.
//

import UIKit
import Combine
import Kingfisher

class ToDoDetailViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var badgeImageView: UIImageView!
    @IBOutlet private weak var nameLeagueLabel: UILabel!
    @IBOutlet private weak var formedYearLable: UILabel!
    @IBOutlet private weak var countryLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var photoImageView: UIImageView!
    
    // MARK: - Properties
    var viewModel: ToDoDetailViewModel?
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel?.transform(
            .init(
                loadData: Just(()).eraseToAnyPublisher()
            )
        ).result.receive(on: RunLoop.main)
        .sink(receiveValue: { result in
            switch result {
            case .success(let item):
                self.title = "Detail " + item.strLeague
                self.nameLeagueLabel.text = item.strLeague
                self.formedYearLable.text = item.intFormedYear
                self.countryLabel.text = item.strCountry
                self.textLabel.text = item.strDescriptionEN
                self.logoImageView.setImage(path: item.strLogo ?? "", placeholder: #imageLiteral(resourceName: "img-logo"))
                self.badgeImageView.setImage(path: item.strBadge ?? "", placeholder: #imageLiteral(resourceName: "img-DefaultImage"))
                self.photoImageView.setImage(path: item.strFanart1 ?? "", placeholder: #imageLiteral(resourceName: "logo"))
            case .failure(_):
                print("No todos found")
            }
        }).store(in: &cancellables)
    }

}
