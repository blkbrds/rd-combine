//
//  EditViewController.swift
//  CombineTest1
//
//  Created by NganHa on 28/02/2021.
//

import UIKit

final class EditViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var addressTextField: UITextField!
    @IBOutlet private weak var doneButton: UIButton!

    // MARK: - Propeties
    var viewModel: EditViewModel? 
    // MARK: - Initialize
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    // MARK: - Override functions
    
    // MARK: - Private functions
    private func setUpUI() {
        doneButton.layer.cornerRadius = 10
        doneButton.clipsToBounds = true
        nameTextField.layer.borderWidth = 0.5
        nameTextField.layer.borderColor = UIColor.black.cgColor
        addressTextField.layer.borderWidth = 0.5
        addressTextField.layer.borderColor = UIColor.black.cgColor
    }
    // MARK: - Public functions
    
    // MARK: - Objc functions
    
    // MARK: - IBActions
    @IBAction private func doneButtonTouchUpInside(_ sender: UIButton) {
        
    }

    @IBAction private func exitButtonTouchUpInside(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
