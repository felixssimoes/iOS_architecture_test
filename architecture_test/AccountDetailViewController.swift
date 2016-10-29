//
//  AccountDetailViewController.swift
//  architecture_test
//
//  Created by Félix Simões on 28/10/16.
//
//

import UIKit

class AccountDetailViewController: UIViewController {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var nameField: UITextField!

    var viewModel: AccountDetailViewModel!

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
