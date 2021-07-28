//
//  UIViewControllerExts.swift
//  CocktailChoose
//
//  Created by Thanh Nguyen X. [4] VN.Danang on 07/28/21.
//

import UIKit.UIViewController
import Combine

extension UIViewController {
    func alert(title: String, message: String) -> AnyPublisher<Void, Never> {

        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)

        return Future { resolve in
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                resolve(.success(()))
            }))

            self.present(alertVC, animated: true, completion: nil)
        }
        .handleEvents(receiveCancel: {
            self.dismiss(animated: true)
        })
        .eraseToAnyPublisher()
    }
}
