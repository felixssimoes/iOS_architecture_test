//
//  TransactionsListViewModel.swift
//  architecture_test
//
//  Created by Felix Simoes on 31/10/2016.
//
//

import Foundation
import RxSwift

class TransactionsListViewModel {
    private let dataSource: DataSource
    private let account: AccountModel
    private var transactions: [TransactionModel] = []
    
    let title: String
    
    init(account: AccountModel, dataStore: DataSource) {
        self.account = account
        self.dataSource = dataStore
        
        title = "\(account.name)'s transactions"
    }
    
    var numberOfTransactions: Int {
        return transactions.count
    }
    
    func transaction(at index: Int) -> TransactionModel? {
        guard index < numberOfTransactions else { return nil }
        return transactions[index]
    }
    
    func reloadData() -> Observable<Void> {
        return dataSource.transactions(forAccount: account).allTransactions()
            .flatMap { transactions -> Observable<Void> in
                self.transactions = transactions
                return Observable.just()
        }
    }
}
