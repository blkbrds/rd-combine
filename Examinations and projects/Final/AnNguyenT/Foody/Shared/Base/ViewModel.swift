//
//  ViewModel.swift
//  Foody
//
//  Created by An Nguyễn on 4/5/21.
//

import Combine
import SwiftUI
import SwifterSwift

class ViewModel {
    lazy var subscriptions = Set<AnyCancellable>()
    @Published var isLoading: Bool = false {
        didSet {
            UIApplication.shared.rootViewController?.view.isUserInteractionEnabled = !isLoading
            UIApplication.shared.topmostViewController?.view.isUserInteractionEnabled = !isLoading
        }
    }
    @Published var error: CommonError?
    @Published var success: CommonError?
    @Published var alertContent: PopupContent?
    var tabIndex: Int? { nil }
    
    init() {
        if let _ = tabIndex {
            NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: .refreshTab, object: nil)
        }
        guard Session.shared.currentTab == tabIndex else {
            print("DEBUG - Return and can't get init data! Tab - \(Session.shared.currentTab)")
            return
        }
        setupData()
        checkUserState() // TEST
    }
    
    func setupData() {
        
    }
    
    func checkUserState() {
        AccountService.getInformation()
            .sink { (completion) in
                if case .failure(let error) = completion {
                    self.error = error
                }
            } receiveValue: { (res) in
                Session.shared.user = res.user
                print("DEBUG - USER STATUE \(res.user.status)")
                if !res.user.isActive {
                    self.error = .isBlocked
                }
            }
            .store(in: &subscriptions)
    }
    
    @objc func refreshData(_ notification: Notification) {
        guard let index = notification.object as? Int, index == tabIndex else {
            return
        }
        setupData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("DEINIT \(String(describing: self)) \(Date())")
    }
}
