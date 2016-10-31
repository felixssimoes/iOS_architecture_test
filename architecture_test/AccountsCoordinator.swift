//
//  AccountsCoordinator.swift
//  architecture_test
//
//  Created by Felix Simoes on 29/10/2016.
//
//

import Foundation
import UIKit

class AccountsCoordinator {
    private let navigationController: UINavigationController
    private let dataStore: DataStore
    private var storyboard = UIStoryboard(name: "Accounts", bundle: nil)

    init(navigationController: UINavigationController, dataStore: DataStore) {
        self.navigationController = navigationController
        self.dataStore = dataStore
    }
    
    func start() {
        showAccountsList()
    }
    
    private func showAccountsList() {
        let vc = storyboard.instantiateViewController(withIdentifier: "AccountsList") as! AccountsListViewController
        vc.viewModel = AccountsListViewModel(accountsDataProvider: dataStore.accounts())
        vc.viewModel.selectAccountCallback = { account in
            self.showTransactions(forAccount: account)
        }
        vc.viewModel.selectAccountDetailCallback = { account in
            self.showDetail(forAccount: account)
        }
        vc.viewModel.addAccountCallback = {
            self.showDetail(forAccount: nil)
        }
        
        navigationController.viewControllers = [vc]
    }
    
    private func showDetail(forAccount account: Account?) {
        let vc = storyboard.instantiateViewController(withIdentifier: "AccountDetail") as! AccountDetailViewController
        let nc = UINavigationController(rootViewController: vc)
        
        vc.viewModel = AccountDetailViewModel(account: account, accountsDataProvider: dataStore.accounts())
        vc.viewModel.cancelCallback = {
            nc.dismiss(animated: true, completion: nil)
        }
        vc.viewModel.saveCallback = {
            nc.dismiss(animated: true, completion: nil)
        }
        
        navigationController.present(nc, animated: true, completion: nil)
    }
    
    private func showTransactions(forAccount account: Account) {
        let transactionsCoordinator = TransactionsCoordinator(account: account, navigationController: navigationController, dataStore: dataStore)
        transactionsCoordinator.start()
    }
}
