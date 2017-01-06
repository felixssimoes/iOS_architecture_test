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
    private let dataSource: DataSource
    private let account: AccountModel
    
    private let storyboard = UIStoryboard(name: "Transactions", bundle: nil)
    
    init(account: AccountModel, navigationController: UINavigationController, dataSource: DataSource) {
        self.navigationController = navigationController
        self.dataSource = dataSource
        self.account = account
    }
    
    func start() {
        showTransactionsList()
    }
    
    private func showTransactionsList() {
        let vc = storyboard.instantiateViewController(withIdentifier: "TransactionsList") as! TransactionsListViewController
        vc.viewModel = TransactionsListViewModel(account: account, dataStore: dataSource)
        vc.navigation = TransactionsListNavigation(onNewTransaction: {
            self.showNewTransaction()
        }, onSelectTransaction: { transaction in
            self.showDetail(forTransaction: transaction)
        })

        navigationController.pushViewController(vc, animated: true)
    }

    private func showDetail(forTransaction transaction: TransactionModel) {
        let vc = storyboard.instantiateViewController(withIdentifier: "TransactionDetail") as! TransactionDetailViewController

        vc.viewModel = TransactionDetailViewModel(transaction: transaction, dataStore: dataSource)
        vc.navigation = TransactionDetailNavigation(onSave: {
            self.navigationController.popViewController(animated: true)
        }, onCancel: {
            self.navigationController.popViewController(animated: true)
        }, onEditCategory: { category in
            let value = TextValue(label: "Category", value: category)
            let c = EditorsCoordinator(navigationController: self.navigationController)
            c.startTextEditor(value: value) { category in
                vc.viewModel.category = category
            }
        }, onEditDate: { date in

        }, onEditAmount: { decimal in

        })

        navigationController.pushViewController(vc, animated: true)
    }

    private func showNewTransaction() {
        let vc = storyboard.instantiateViewController(withIdentifier: "TransactionDetail") as! TransactionDetailViewController
        let nc = UINavigationController(rootViewController: vc)

        vc.viewModel = TransactionDetailViewModel(account: account, dataStore: dataSource)
        vc.navigation = TransactionDetailNavigation(onSave: {
            nc.dismiss(animated: true)
        }, onCancel: {
            nc.dismiss(animated: true)
        }, onEditCategory: { category in
            let value = TextValue(label: "Category", value: category)
            let c = EditorsCoordinator(navigationController: nc)
            c.startTextEditor(value: value) { category in
                vc.viewModel.category = category
            }
        }, onEditDate: { date in

        }, onEditAmount: { decimal in
            
        })

        navigationController.present(nc, animated: true)
    }
}
