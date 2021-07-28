//
//  ViewControllerExts.swift
//  FinalProject_Combine
//
//  Created by An Nguyen Q. VN.Danang on 7/16/21.
//

import Foundation
import UIKit

extension UIViewController {
    func showError(_ errorMessage: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
                case .default:
                print("default")
                    if let completion = completion {
                        completion()
                    }
                
                case .cancel:
                print("cancel")
                
                case .destructive:
                print("destructive")
                
            @unknown default:
                print("unknown")
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
