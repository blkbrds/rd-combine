//
//  HomeViewController.swift
//  MVVMCombine
//
//  Created by Huy Vo D. [2] VN.Danang on 7/30/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import UIKit

final class HomeViewController: ViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    
    enum Section: Int, CaseIterable {
        case list
    }

    typealias DataSource = UITableViewDiffableDataSource<Section, Book>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Book>
    
    typealias CoDataSource = UICollectionViewDiffableDataSource<Section, Book>

    private var dataSource: DataSource!
    private var coDataSource: CoDataSource!

    var viewModel: HomeViewModel = HomeViewModel()
    
    override var viewModelType: ViewModelType? {
        get {
            return viewModel
        }
        set {
            super.viewModelType = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configNavigationBar()
    }
    
    override func setupUI() {
        super.setupUI()
        configSearchView()
        configTableView()
        configCollectionView()
    }
    
    override func setupData() {
        super.setupData()
        viewModel.performGetListBook()
    }
    
    override func binding() {
        super.binding()
        bindingView()
        bindingViewModel()
    }
    
    private func bindingView() {
        searchTextField.publisher(for: .editingChanged).sink { [weak self] _ in
            guard let text = self?.searchTextField.text else { return }
            self?.viewModel.keyWord.send(text)
        }.store(in: &subscriptions)
    }
    
    private func bindingViewModel() {
        viewModel.$apiResult
            .handle(onFailure: { [weak self] in
                self?.alert(error: $0)
            })
            .store(in: &subscriptions)
        
        viewModel.$coApiResult
            .handle(onFailure: { [weak self] in
                self?.alert(error: $0)
            })
        .store(in: &subscriptions)

        viewModel.books
            .sink { [weak self] in
                guard let this = self else { return }
                this.applySnapshot($0, moveToTop: this.viewModel.books.value.count <= this.viewModel.limit)
            }
            .store(in: &subscriptions)
        
        viewModel.newBooks
            .sink { [weak self] in
                guard let this = self else { return }
                this.applyCoSnapshot($0)
            }
            .store(in: &subscriptions)
    }
    
    private func configTableView() {
        tableView.register(BookCell.self)
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 100

        // make data source for collection view
        dataSource = DataSource(
            tableView: tableView,
            cellProvider: { (tableView, indexPath, data) -> TableCell? in
                let cell = tableView.dequeue(cell: BookCell.self, forIndexPath: indexPath)
                cell.viewModel = BookCellVM(book: data)
                return cell
            })
    }

    private func applySnapshot(_ data: [Book], moveToTop: Bool) {
        var snapshot = Snapshot()
        snapshot.appendSections([.list])
        snapshot.appendItems(data, toSection: .list)
        dataSource.apply(snapshot, animatingDifferences: true) { [weak self] in
            guard let this = self else { return }
            if moveToTop {
                this.tableView.setContentOffset(CGPoint(x: this.tableView.contentOffset.x, y: 0), animated: false)
            }
        }
    }
    
    private func configCollectionView() {
        collectionView.register(NewBookCell.self)
        
        coDataSource = CoDataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, data) -> UICollectionViewCell? in
            let cell = collectionView.dequeue(cell: NewBookCell.self, forIndexPath: indexPath)
            cell.viewModel = NewBookCellVM(imageURL: data.image ?? "")
            return cell
        })
    }
    
    private func applyCoSnapshot(_ data: [Book]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.list])
        snapshot.appendItems(data, toSection: .list)
        coDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func configSearchView() {
        searchView.layer.cornerRadius = 5
    }
    
    private func configNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let book = coDataSource.itemIdentifier(for: indexPath) else { return }
        let vc = BookDetailViewController()
        vc.viewModel = BookDetailViewModel(id: book.isbn13 ?? "")
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let book = dataSource.itemIdentifier(for: indexPath) else { return }
        let vc = BookDetailViewController()
        vc.viewModel = BookDetailViewModel(id: book.isbn13 ?? "")
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UIScrollViewDelegate
extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView == tableView else { return }
        let contentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if maximumOffset - contentOffset <= 10 {
            viewModel.performLoadMoreListBook()
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard scrollView == tableView else { return }
        if !decelerate {
            let contentOffset = scrollView.contentOffset.y
            let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
            if maximumOffset - contentOffset <= 10 {
                viewModel.performLoadMoreListBook()
            }
        }
    }
}
