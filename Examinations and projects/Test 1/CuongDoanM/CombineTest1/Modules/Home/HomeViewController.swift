//
//  HomeViewController.swift
//  CombineTest1
//
//  Created by Cuong Doan M. on 2/26/21.
//

import UIKit
import Combine

final class HomeViewController: UIViewController {
    
    @IBOutlet private var infoViews: [InfoView]!
    
    private let people: [Person] = [
        Person(name: "Cuong Doan M.", address: "Da Nang"),
        Person(name: "Cuong Doan M.", address: "Da Nang"),
        Person(name: "Cuong Doan M.", address: "Da Nang"),
        Person(name: "Cuong Doan M.", address: "Da Nang")
    ]
    private var subscriptions: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        addObserver()
    }
    
    private func setupBindings() {
        infoViews.forEach { view in
            guard let pattern: Pattern = Pattern(rawValue: view.tag),
                let person: Person = people[safe: view.tag] else {
                return
            }
            view.pattern = pattern
            view.bind(to: person)
            switch pattern {
            case .delegate:
                // [1][Edit] - Delegate - Delegate to self
                view.delegate = self
            case .closure:
                // [2][Edit] - Closure - Define closure
                view.editHandler = {
                    self.handleEditAction(withPattern: .closure)
                }
            case .notification:
                break
            case .combine:
                // [4][Edit] - Combine - Receive value
                view.editPublisher
                    .sink(receiveValue: {
                        self.handleEditAction(withPattern: .combine)
                    })
                    .store(in: &subscriptions)
            }
        }
    }
    
    private func addObserver() {
        let center: NotificationCenter = NotificationCenter.default
        // [3][Edit] - Notification - Add observer to receive notification
        center.addObserver(self, selector: #selector(editInformation), name: .EditInformation, object: nil)
        // [3][Update] - Notification - Add observer to receive notification
        center.addObserver(self, selector: #selector(updateInformation), name: .UpdateInformation, object: nil)
    }
    
    // [3][Edit] - Notification - Handle after receive notification
    @objc private func editInformation(_ notification: Notification) {
        handleEditAction(withPattern: .notification)
    }
    
    // [3][Update] - Notification - Handle after receive notification
    @objc private func updateInformation(_ notification: Notification) {
        guard let person: Person = notification.object as? Person else {
            return
        }
        handleUpdateAction(withPattern: .notification, person: person)
    }
    
    private func handleEditAction(withPattern pattern: Pattern) {
        guard let person: Person = people[safe: pattern.rawValue] else {
            return
        }
        let vc: EditViewController = EditViewController(person: person.copy())
        vc.pattern = pattern
        switch pattern {
        case .delegate:
            // [1][Update] - Delegate - Delegate to self
            vc.delegate = self
        case .closure:
            // [2][Update] - Closure - Define closure
            vc.updateHandler = { person in
                self.handleUpdateAction(withPattern: pattern, person: person)
            }
        case .notification:
            break
        case .combine:
            // [4][Update] - Combine - Receive value
            vc.updatePublisher
                .sink(receiveValue: { person in
                    self.handleUpdateAction(withPattern: pattern, person: person)
                })
                .store(in: &subscriptions)
        }
        present(vc, animated: true)
    }
    
    private func handleUpdateAction(withPattern pattern: Pattern, person: Person) {
        guard let current: Person = people[safe: pattern.rawValue] else {
            return
        }
        current.update(from: person)
    }
}

// [1][Edit] - Delegate - Implement delegate
extension HomeViewController: InfoViewDelegate {
    func view(_ view: InfoView, needsPerform action: Action<Person>) {
        switch action {
        case .edit:
            handleEditAction(withPattern: .delegate)
        default:
            break
        }
    }
}

// [1][Update] - Delegate - Implement delegate
extension HomeViewController: EditViewControllerDelegate {
    func controller(_ controller: EditViewController, needsPerform action: Action<Person>) {
        switch action {
        case .update(let person):
            handleUpdateAction(withPattern: .delegate, person: person)
        default:
            break
        }
    }
}
