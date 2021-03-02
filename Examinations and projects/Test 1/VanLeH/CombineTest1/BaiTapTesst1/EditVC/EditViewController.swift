//
//  EditViewController.swift
//  CombineTest1
//
//  Created by PCI0015 on 3/2/21.
//

import UIKit

final class EditViewController: UIViewController {

    @IBOutlet private weak var editButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    private func configUI() {
        editButton.layer.cornerRadius = 8
    }
}
