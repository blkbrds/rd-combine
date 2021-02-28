//
//  HomeViewController.swift
//  CombineTest1
//
//  Created by Quoc Doan M. on 2/28/21.
//

import UIKit

final class HomeViewController: UIViewController {

    @IBOutlet private weak var collectionView: UICollectionView!

    var viewModel: HomeViewModel = HomeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: Define.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: Define.cellIdentifier)
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI(_:)), name: Notification.Name.init(rawValue: "NotificationCenter"), object: nil)
    }

    @objc private func updateUI(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let indexPath = viewModel.indexPath else { return }
        let name: String = userInfo["name"] as? String ?? ""
        let address: String = userInfo["address"] as? String ?? ""
        viewModel.user = User(name: name, address: address)
        let indexPaths: [IndexPath] = [IndexPath(row: indexPath.row, section: indexPath.section)]
        collectionView.reloadItems(at: indexPaths)
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems(in: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: CustomCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: Define.cellIdentifier, for: indexPath) as? CustomCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.viewModel = viewModel.cellForItem(at: indexPath)
        cell.delegate = self
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (UIScreen.main.bounds.width - 20) / 2
        let height: CGFloat = (UIScreen.main.bounds.height - 8) / 2
        return CGSize(width: width, height:  height)
    }
}

// MARK: - CustomCollectionViewCellDelegate
extension HomeViewController: CustomCollectionViewCellDelegate {
    func cell(_ cell: CustomCollectionViewCell, needsPerform action: CustomCollectionViewCell.Action) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        viewModel.indexPath = indexPath
        let vc = EditViewController()
        vc.viewModel = viewModel.getEditViewModel()
        // Closure
        vc.closure = { [weak self] (value) in
            guard let indexPath = self?.viewModel.indexPath else { return }
            self?.viewModel.user = value
            let indexPaths: [IndexPath] = [IndexPath(row: indexPath.row, section: indexPath.section)]
            self?.collectionView.reloadItems(at: indexPaths)
        }

        // Delegate
        vc.delegate = self
        // Present edit view controller
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true, completion: nil)
    }
}

// MARK: - EditViewControllerDelegate
extension HomeViewController: EditViewControllerDelegate {
    func vc(_ vc: EditViewController, needsPerform action: EditViewController.Action) {
        switch action {
        case .didSelectedBackButton(let user):
            guard let indexPath = viewModel.indexPath else { return }
            viewModel.user = user
            let indexPaths: [IndexPath] = [IndexPath(row: indexPath.row, section: indexPath.section)]
            collectionView.reloadItems(at: indexPaths)
        }
    }
}

// Define
extension HomeViewController {
    private struct Define {
        static let cellIdentifier: String = "CustomCollectionViewCell"
    }
}
