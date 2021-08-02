//
//  ProfileViewModel.swift
//  FinalCombine
//
//  Created by Quoc  Doan M. VN.Danang on 8/2/21.
//

import Foundation
import Combine

final class ProfileViewModel {

    enum ProfileType: String, CaseIterable {
        case termOfService
        case changePassword
        case version
        case aboutApp

        var title: String {
            switch self {
            case .termOfService:
                return "Term of Service"
            case .changePassword:
                return "Change Password"
            case .version:
                return "Verion API"
            case .aboutApp:
                return "About App"
            }
        }
    }

    @Published private(set) var others: [ProfileType] = ProfileType.allCases.map { (ProfileType(rawValue: $0.rawValue) ?? .termOfService) }
}

// MARK: - Table view
extension ProfileViewModel {
    func numberOfRows(in section: Int) -> Int {
        return others.count
    }

    func viewModelForItem(at indexPath: IndexPath) {}
}
