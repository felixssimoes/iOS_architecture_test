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
    private let dataSource: DataSource
    private var storyboard = UIStoryboard(name: "Accounts", bundle: nil)

    init(navigationController: UINavigationController, dataSource: DataSource) {
        self.navigationController = navigationController
        self.dataSource = dataSource
    }
    
    func start() {
        showAccountsList()
    }
    
    private func showAccountsList() {
        let vc = storyboard.instantiateViewController(withIdentifier: "AccountsList") as! AccountsListViewController
        vc.viewModel = AccountsListViewModel(accountsDataProvider: dataSource.accounts())
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
    
    private func showDetail(forAccount account: AccountModel?) {
        let vc = storyboard.instantiateViewController(withIdentifier: "AccountDetail") as! AccountDetailViewController
        let nc = UINavigationController(rootViewController: vc)
        
        vc.viewModel = AccountDetailViewModel(account: account, accountsDataProvider: dataSource.accounts())
        vc.viewModel.cancelCallback = {
            nc.dismiss(animated: true, completion: nil)
        }
        vc.viewModel.saveCallback = {
            nc.dismiss(animated: true, completion: nil)
        }
        
        navigationController.present(nc, animated: true, completion: nil)
    }
    
    private func showTransactions(forAccount account: AccountModel) {
        let transactionsCoordinator = TransactionsCoordinator(account: account, navigationController: navigationController, dataSource: dataSource)
        transactionsCoordinator.start()
    }
}
