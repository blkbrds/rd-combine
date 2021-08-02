//
//  UIViewControllerExt.swift
//  MVVMCombine
//
//  Created by MBA0242P on 4/23/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import UIKit
import Combine

extension UIViewController {

    @discardableResult
    func alert(
        error: Error,
        actions: [(title: String, handler: (() -> Void)?)] = [("OK", nil)]
    ) -> AnyPublisher<Void, Never> {
        return alert(title: "", message: error.localizedDescription, actions: actions)
    }

    func showAlert(error: String) {
        let alert = UIAlertController(title: "Warning", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @discardableResult
    func alert(
        title: String = "",
        message: String,
        actions: [(title: String, handler: (() -> Void)?)] = [("OK", nil)]
    ) -> AnyPublisher<Void, Never> {

        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)

        return Future { resolve in
            for action in actions {
                alertVC.addAction(UIAlertAction(title: action.title, style: .default, handler: { _ in
                    action.handler?()
                    resolve(.success(()))
                }))
            }

            self.present(alertVC, animated: true, completion: nil)
        }
        .handleEvents(receiveCancel: {
            self.dismiss(animated: true)
        })
        .eraseToAnyPublisher()
    }
}
