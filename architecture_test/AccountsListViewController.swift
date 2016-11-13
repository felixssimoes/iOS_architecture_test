//
//  AccountsListViewController.swift
//  architecture_test
//
//  Created by Félix Simões on 28/10/16.
//
//

import UIKit

struct AccountsListNavigation {
    var onNewAccount: (() -> Void)?
    var onSelectAccount: ((AccountModel) -> Void)?
    var onShowDetailsForAccount: ((AccountModel) -> Void)?
}

class AccountsListViewController: UITableViewController {

    var viewModel: AccountsListViewModel!
    var navigation: AccountsListNavigation?
    
    // MARK: - View controller lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.reloadData { _ in
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Actions
    
    @IBAction func didSelectAddButton() {
        navigation?.onNewAccount?()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfAccounts
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountListCell", for: indexPath)
        if let account = viewModel.account(at: indexPath.row) {
            cell.textLabel?.text = account.name
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let account = viewModel.account(at: indexPath.row) {
            navigation?.onSelectAccount?(account)
        }
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        if let account = viewModel.account(at: indexPath.row) {
            navigation?.onShowDetailsForAccount?(account)
        }
    }
}
