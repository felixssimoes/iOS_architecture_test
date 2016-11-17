//
//  AccountDetailViewController.swift
//  architecture_test
//
//  Created by Félix Simões on 28/10/16.
//
//

import UIKit
import RxSwift

struct AccountDetailNavigation {
    var onSave: (() -> Void)?
    var onCancel: (() -> Void)?
}

class AccountDetailViewController: UIViewController {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var nameField: UITextField!

    var viewModel: AccountDetailViewModel!
    var navigation: AccountDetailNavigation?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameField.text = viewModel.name
        nameField.becomeFirstResponder()
    }

    @IBAction func didSelectSaveButton() {
        viewModel.name = nameField.text ?? ""
        viewModel.saveAccount()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { _ in
                self.navigation?.onSave?()
            }, onError: { error in
                print(error)
            }).dispose()
    }

    @IBAction func didSelectCancelButton() {
        navigation?.onCancel?()
    }
}
