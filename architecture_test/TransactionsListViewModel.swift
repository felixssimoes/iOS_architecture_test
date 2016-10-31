//
//  TransactionsListViewModel.swift
//  architecture_test
//
//  Created by Felix Simoes on 31/10/2016.
//
//

import Foundation

class TransactionsListViewModel {
    private let dataStore: DataStore
    private let account: AccountModel
    private var transactions: [TransactionModel] = []
    
    let title: String
    
    init(account: AccountModel, dataStore: DataStore) {
        self.account = account
        self.dataStore = dataStore
        
        title = "\(account.name)'s transactions"
    }
    
    var numberOfTransactions: Int {
        return transactions.count
    }
    
    func transaction(at index: Int) -> TransactionModel? {
        guard index < numberOfTransactions else { return nil }
        return transactions[index]
    }
    
    func reloadData(completion: @escaping (Result<Void, TransactionError>) -> Void) {
        dataStore.transactions(forAccount: account).allTransactions { result in
            switch result {
            case.success(let transactions):
                self.transactions = transactions
                completion(.success())
            
            case .failure(let e):
                completion(.failure(e))
            }
        }
    }
}
