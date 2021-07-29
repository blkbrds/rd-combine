//
//  TeamViewController.swift
//  MVVMCombine
//
//  Created by Tam Nguyen K. T. [7] VN.Danang on 7/16/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import UIKit
import Combine

final class TeamViewController: ViewController {

    // MARK: - IBOulets
    @IBOutlet private weak var tableView: UITableView!

    enum Section: Int, CaseIterable {
        case list
    }
    typealias DataSource = UITableViewDiffableDataSource<Section, Team>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Team>
    private var dataSource: DataSource!

    // MARK: - Properties
    var viewModel = TeamViewModel()
    let searchViewController = UISearchController()
    override var viewModelType: ViewModelType? {
        get {
            return viewModel
        }
        set {
            return super.viewModelType = newValue
        }
    }
    // MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Premier League"
        navigationItem.searchController = searchViewController
        searchViewController.searchResultsUpdater = self
        searchViewController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
    }

    override func setupUI() {
        super.setupUI()
        configTableView()
    }

    override func setupData() {
        super.setupData()
        viewModel.action.send(.fetchData)
        viewModel.action.send(.handleFilter)
    }

    override func binding() {
        super.binding()
        viewModel.$apiResult
            .handle(onSucess: { [weak self] in
            self?.viewModel.filterA = $0
            self?.applySnapshot(data: $0)
        }, onFailure: { [weak self] in
                self?.alert(error: $0)
            })
            .store(in: &subscriptions)
    }

    // MARK: - Private methods
    private func configTableView() {
        tableView.register(TeamTableViewCell.self)
        tableView.rowHeight = 200
        makeDataSource()
    }

    private func makeDataSource() {
        dataSource = DataSource(tableView: tableView, cellProvider: { (tableView, indexPath, item) -> UITableViewCell? in
            let cell = tableView.dequeue(cell: TeamTableViewCell.self, forIndexPath: indexPath)
            cell.viewModel = TeamCellViewModel(logo: item.strTeamBadge, nameClub: item.strAlternate, nameStadium: item.strStadium, intFormedYear: String(item.intFormedYear))
            return cell
        })
    }

    private func applySnapshot(data: [Team]) {
        var snapShot = Snapshot()

        snapShot.appendSections([.list])
        snapShot.appendItems(data, toSection: .list)

        dataSource.apply(snapShot, animatingDifferences: true, completion: nil)
    }
}

extension TeamViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        if text.isEmpty {
            applySnapshot(data: viewModel.filterA)
        } else {
            viewModel.searchText.send(text)
            applySnapshot(data: viewModel.filter)
        }
    }
}

extension TeamViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let team = dataSource.itemIdentifier(for: indexPath) else { return }
        let vc = DetailTeamViewController()
//        vc.viewModel = DetailTeamViewModel(team: team)
        vc.viewModel = DetailTeamViewModel(strAlternate: team.strAlternate, strTeamBadge: team.strTeamBadge, strTeamFanart1: team.strTeamFanart1, strTeamFanart2: team.strTeamFanart2, strTeamFanart3: team.strTeamFanart3, strTeamFanart4: team.strTeamFanart4, strStadiumLocation: team.strStadiumLocation, strFacebook: team.strFacebook, strInstagram: team.strInstagram, strTwitter: team.strInstagram, strWebside: team.strWebsite, strDescriptionEN: team.strDescriptionEN)
        navigationController?.pushViewController(vc, animated: true)
    }
}
