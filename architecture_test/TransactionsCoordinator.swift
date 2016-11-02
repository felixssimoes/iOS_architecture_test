//
//  TransactionsCoordinator.swift
//  architecture_test
//
//  Created by Felix Simoes on 31/10/2016.
//
//

import Foundation
import UIKit

class TransactionsCoordinator {
    private let navigationController: UINavigationController
    private let dataStore: DataStore
    private let account: AccountModel
    
    private let storyboard = UIStoryboard(name: "Transactions", bundle: nil)
    
    init(account: AccountModel, navigationController: UINavigationController, dataStore: DataStore) {
        self.navigationController = navigationController
        self.dataStore = dataStore
        self.account = account
    }
    
    func start() {
        showTransactionsList()
    }
    
    private func showTransactionsList() {
        let vc = storyboard.instantiateViewController(withIdentifier: "TransactionsList") as! TransactionsListViewController
        vc.viewModel = TransactionsListViewModel(account: account, dataStore: dataStore)
        vc.viewModel.newTransactionCallback = {
            self.showNewTransaction()
        }
        vc.viewModel.selectTransactionCallback = { transaction in
            self.showDetail(forTransaction: transaction)
        }
        navigationController.pushViewController(vc, animated: true)
    }

    private func showDetail(forTransaction transaction: TransactionModel) {
        let vc = storyboard.instantiateViewController(withIdentifier: "TransactionDetail") as! TransactionDetailViewController

        vc.viewModel = TransactionDetailViewModel(transaction: transaction, dataStore: dataStore)
        vc.viewModel.cancelCallback = {
            self.navigationController.popViewController(animated: true)
        }
        vc.viewModel.saveCallback = {
            self.navigationController.popViewController(animated: true)
        }

        navigationController.pushViewController(vc, animated: true)
    }

    private func showNewTransaction() {
        let vc = storyboard.instantiateViewController(withIdentifier: "TransactionDetail") as! TransactionDetailViewController
        let nc = UINavigationController(rootViewController: vc)

        vc.viewModel = TransactionDetailViewModel(account: account, dataStore: dataStore)
        vc.viewModel.cancelCallback = {
            nc.dismiss(animated: true)
        }
        vc.viewModel.saveCallback = {
            nc.dismiss(animated: true)
        }

        navigationController.present(nc, animated: true)
    }
}
