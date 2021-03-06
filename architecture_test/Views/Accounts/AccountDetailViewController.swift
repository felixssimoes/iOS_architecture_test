//
//  AccountDetailViewController.swift
//  architecture_test
//
//  Created by Félix Simões on 28/10/16.
//
//

import UIKit

struct AccountDetailNavigation {
    var onSave: (() -> Void)?
    var onCancel: (() -> Void)?
}

class AccountDetailViewController: UIViewController {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var nameField: UITextField!

    private (set) var viewModel: AccountDetailViewModel!
    var navigation: AccountDetailNavigation?
    
    static func new(viewModel: AccountDetailViewModel) -> AccountDetailViewController {
        let sb = AppStoryboard.accounts.instance
        let vc = sb.instantiateViewController(withIdentifier: "AccountDetail") as! AccountDetailViewController
        vc.viewModel = viewModel
        return vc
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameField.text = viewModel.name
        nameField.becomeFirstResponder()
    }

    @IBAction func didSelectSaveButton() {
        viewModel.name = nameField.text ?? ""
        viewModel.saveAccount { (result) in
            switch result {
            case .success: self.navigation?.onSave?()
            case .failure(let error): print(error)
            }
        }
    }

    @IBAction func didSelectCancelButton() {
        navigation?.onCancel?()
    }
}
