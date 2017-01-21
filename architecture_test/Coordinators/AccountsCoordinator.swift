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

    init(navigationController: UINavigationController, dataSource: DataSource) {
        self.navigationController = navigationController
        self.dataSource = dataSource
    }
    
    func start() {
        showAccountsList()
    }
    
    private func showAccountsList() {
        let vm = AccountsListViewModel(accountsDataProvider: dataSource.accounts())
        let vc = AccountsListViewController.new(viewModel: vm)
        vc.navigation = AccountsListNavigation(onNewAccount: {
            self.showDetail(forAccount: nil)
        }, onSelectAccount: { account in
            self.showTransactions(forAccount: account)
        }, onShowDetailsForAccount: { account in
            self.showDetail(forAccount: account)
        })

        navigationController.viewControllers = [vc]
    }
    
    private func showDetail(forAccount account: AccountModel?) {
        let vm = AccountDetailViewModel(account: account, accountsDataProvider: dataSource.accounts())
        let vc = AccountDetailViewController.new(viewModel: vm)
        let nc = UINavigationController(rootViewController: vc)
        
        vc.navigation = AccountDetailNavigation(onSave: {
            nc.dismiss(animated: true, completion: nil)
        }, onCancel: {
            nc.dismiss(animated: true, completion: nil)
        })

        navigationController.present(nc, animated: true, completion: nil)
    }

    private func showTransactions(forAccount account: AccountModel) {
        let transactionsCoordinator = TransactionsCoordinator(account: account, navigationController: navigationController, dataSource: dataSource)
        transactionsCoordinator.start()
    }
}
