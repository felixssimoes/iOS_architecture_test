//
//  AccountDetailViewController.swift
//  architecture_test
//
//  Created by Félix Simões on 28/10/16.
//
//

import UIKit

class AccountDetailViewController: UIViewController {

    private var nameLabel: UILabel!
    private var nameField: UITextField!

    var viewModel: AccountDetailViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        var frame = view.bounds
        frame.origin.y += 70
        frame.size.height = 25
        nameLabel = UILabel(frame: frame)
        nameLabel.autoresizingMask = [.flexibleWidth]
        nameLabel.text = "Account name"
        view.addSubview(nameLabel)

        frame.origin.y += 30
        frame.size.height = 30
        nameField = UITextField(frame: frame)
        nameField.autoresizingMask = [.flexibleWidth]
        view.addSubview(nameField)

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.didSelectSaveButton))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.didSelectCancelButton))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameField.text = viewModel.name
        nameField.becomeFirstResponder()
    }

    @IBAction func didSelectSaveButton() {
        viewModel.name = nameField.text ?? ""
        viewModel.saveAccount { (result) in
            if case .failure(let error) = result {
                print(error)
            }
        }
    }

    @IBAction func didSelectCancelButton() {
        viewModel.cancel()
    }
}
