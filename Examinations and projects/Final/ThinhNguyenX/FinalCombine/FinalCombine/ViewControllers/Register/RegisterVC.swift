//
//  RegisterVC.swift
//  FinalCombine
//
//  Created by Thinh Nguyen X. [2] VN.Danang on 8/2/21.
//

import UIKit
import Combine

final class RegisterVC: FcViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var userNameTextField: UITextField!
    @IBOutlet private weak var pwTextField: UITextField!
    @IBOutlet private weak var confirmPWTextField: UITextField!
    @IBOutlet private weak var ageTextField: UITextField!
    @IBOutlet private weak var genderTextField: UITextField!
    @IBOutlet private weak var registerButton: UIButton!

    // MARK: - Properties
    let datePicker = UIDatePicker()
    var viewModel = RegisterViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        setupBindings()
    }

    private func configUI() {
        userNameTextField.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
        pwTextField.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
        ageTextField.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
        confirmPWTextField.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
        genderTextField.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
        configAgePicker()
    }

    private func configAgePicker() {
        if #available(iOS 13.4, *) {
            datePicker.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 216)
            datePicker.preferredDatePickerStyle = .wheels
        }

        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: true)
        ageTextField.inputAccessoryView = toolbar
        ageTextField.inputView = datePicker
        datePicker.datePickerMode = .date

    }

    // MARK: - Private functions
    private func setupBindings() {
        func bindingToView() {
            userNameTextField.publisher(for: .editingChanged)
                .receive(on: DispatchQueue.main)
                .compactMap { $0.text }
                .assign(to: \.username, on: viewModel)
                .store(in: &viewModel.stores)

            pwTextField.publisher(for: .editingChanged)
                .receive(on: DispatchQueue.main)
                .compactMap { $0.text }
                .assign(to: \.password, on: viewModel)
                .store(in: &viewModel.stores)

            confirmPWTextField.publisher(for: .editingChanged)
                .receive(on: DispatchQueue.main)
                .compactMap { $0.text }
                .assign(to: \.confirmPW, on: viewModel)
                .store(in: &viewModel.stores)

            ageTextField.publisher(for: .editingChanged)
                .receive(on: DispatchQueue.main)
                .compactMap { $0.text }
                .assign(to: \.age, on: viewModel)
                .store(in: &viewModel.stores)

            genderTextField.publisher(for: .editingChanged)
                .receive(on: DispatchQueue.main)
                .compactMap { $0.text }
                .assign(to: \.gender, on: viewModel)
                .store(in: &viewModel.stores)

            registerButton.publisher(for: \.isHighlighted)
                .sink { highlighted in
                   if highlighted {
                      print("ĐỔI màu đen")
                   } else {
                    print("ĐỔI màu cam")
                   }
                }
                .store(in: &viewModel.stores)
        }

        func bindViewModelToView() {
           
            viewModel.fullValidation
                  .assign(to: \.isEnabled, on: registerButton)
                  .store(in: &viewModel.stores)

        }

        bindingToView()
        bindViewModelToView()
    }
    

    @objc func donePressed() {

        let formater = DateFormatter()
        formater.dateStyle = .medium
        formater.timeStyle = .none
        ageTextField.text = formater.string(from: datePicker.date)
        view.endEditing(true)
    }

    @IBAction private func backButtonTouchUpInside(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
