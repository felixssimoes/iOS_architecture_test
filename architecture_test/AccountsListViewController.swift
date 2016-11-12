//
//  AccountsListViewController.swift
//  architecture_test
//
//  Created by Félix Simões on 28/10/16.
//
//

import UIKit
import RxSwift

class AccountsListViewController: UITableViewController {

    var viewModel: AccountsListViewModel!
    
    // MARK: - View controller lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.reactiveReloadData()
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { _ in
                    self.tableView.reloadData()
                }, onError: { error in
                    print(error)
                }).dispose()
    }
    
    // MARK: - Actions
    
    @IBAction func didSelectAddButton() {
        viewModel.addAccount()
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
        viewModel.selectAccount(at: indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        viewModel.selectAccountDetail(at: indexPath.row)
    }
}
