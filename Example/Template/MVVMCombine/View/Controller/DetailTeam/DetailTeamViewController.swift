//
//  DetailTeamViewController.swift
//  MVVMCombine
//
//  Created by Tam Nguyen K. T. [7] VN.Danang on 7/22/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import UIKit
import SDWebImage
import Combine

final class DetailTeamViewController: ViewController {

    // MARK: - IBOulets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var clubImageView1: UIImageView!
    @IBOutlet private weak var clubImageView2: UIImageView!
    @IBOutlet private weak var clubImageView3: UIImageView!
    @IBOutlet private weak var clubImageView4: UIImageView!
    @IBOutlet private weak var clubImageView5: UIImageView!
    @IBOutlet private weak var websiteLabel: UILabel!
    @IBOutlet private weak var facebookLabel: UILabel!
    @IBOutlet private weak var InstagramLabel: UILabel!
    @IBOutlet private weak var twitterLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!

    @IBOutlet private weak var informationView: InformationView!

    // MARK: - Properties
    var viewModel: DetailTeamViewModel?
    let getData = PassthroughSubject<String, Never>()

    // MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        informationView.isHidden = true
        informationView.dataSource = self
        informationView.updateUI()
    }

    override func setupUI() {
        guard let viewModel = viewModel else { return }
        title = viewModel.team.strAlternate

        guard let url1 = URL(string: viewModel.team.strTeamBadge),
            let url2 = URL(string: viewModel.team.strTeamFanart1),
            let url3 = URL(string: viewModel.team.strTeamFanart2),
            let url4 = URL(string: viewModel.team.strTeamFanart3),
            let url5 = URL(string: viewModel.team.strTeamFanart4) else { return }
        clubImageView1.sd_setImage(with: url1, completed: .none)
        clubImageView2.sd_setImage(with: url2, completed: .none)
        clubImageView3.sd_setImage(with: url3, completed: .none)
        clubImageView4.sd_setImage(with: url4, completed: .none)
        clubImageView5.sd_setImage(with: url5, completed: .none)

        locationLabel.text = viewModel.team.strStadiumLocation
        facebookLabel.text = viewModel.team.strFacebook
        InstagramLabel.text = viewModel.team.strInstagram
        twitterLabel.text = viewModel.team.strTwitter
        websiteLabel.text = viewModel.team.strWebsite

        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(DesciptionTableViewCell.self)
        tableView.register(StadiumTableViewCell.self)
    }

    override func setupData() {
    }

    override func binding() {
        viewModel?.$strAlternate
            .sink(receiveValue: { [weak self] value in
            self?.title = value
        })
            .store(in: &subscriptions)

        viewModel?.$strStadiumLocation

            .assign(to: \.text, on: locationLabel)
            .store(in: &subscriptions)

        viewModel?.$strFacebook
            .assign(to: \.text, on: facebookLabel)
            .store(in: &subscriptions)

        viewModel?.$strInstagram
            .assign(to: \.text, on: InstagramLabel)
            .store(in: &subscriptions)

        viewModel?.$strTwitter
            .assign(to: \.text, on: twitterLabel)
            .store(in: &subscriptions)

        viewModel?.$strWebsite
            .assign(to: \.text, on: websiteLabel)
            .store(in: &subscriptions)
    }
}

extension DetailTeamViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfItem(in: section) ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let typeSection = SectionType(rawValue: indexPath.section) else { return UITableViewCell() }
        switch typeSection {
        case .description:
            let cell = tableView.dequeue(cell: DesciptionTableViewCell.self, forIndexPath: indexPath)
            cell.viewModel = DesciptionViewModel(content: viewModel?.team.strDescriptionEN ?? "")
            return cell
        case .stadium:
            let cell = tableView.dequeue(cell: StadiumTableViewCell.self, forIndexPath: indexPath)
            cell.checkButton
                .handleEvents(receiveOutput: { [weak self] check in
                    if check {
                        self?.informationView.isHidden = false
                        self?.informationView.dataSource = self
                    }
                })
                .sink { _ in }
                .store(in: &subscriptions)
            return cell
        case .player:
            return UITableViewCell()
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel?.setTitleSection(section: section)
    }
}

extension DetailTeamViewController: UITableViewDelegate {
}

extension DetailTeamViewController: InformationViewDataSource {
    func getContent(view: InformationView) -> String {
        return viewModel?.team.strDescriptionEN ?? ""
    }
}
