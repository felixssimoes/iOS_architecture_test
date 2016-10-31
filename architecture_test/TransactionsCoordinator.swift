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
        navigationController.pushViewController(vc, animated: true)
    }
}
