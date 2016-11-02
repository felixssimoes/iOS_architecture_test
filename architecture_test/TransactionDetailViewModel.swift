//
// Created by Felix Simoes on 01/11/2016.
//

import Foundation

class TransactionDetailViewModel {
    private let dataStore: DataStore
    private let transaction: TransactionModel?
    private let account: AccountModel

    var category: String
    var date: Date
    var amount: Decimal

    init(transaction: TransactionModel, dataStore: DataStore) {
        self.dataStore = dataStore
        self.transaction = transaction
        self.account = transaction.account
        self.category = transaction.category
        self.date = transaction.date
        self.amount = transaction.amount
    }

    init(account: AccountModel, dataStore: DataStore) {
        self.dataStore = dataStore
        self.transaction = nil
        self.account = account
        self.category = ""
        self.date = Date()
        self.amount = 0
    }

    var saveCallback:(() -> Void)?
    var cancelCallback:(() -> Void)?

    func cancel() {
        cancelCallback?()
    }

    func save(completion: @escaping (Result<Void, TransactionError>) -> Void) {
        if transaction == nil {
            addNewTransaction(completion: completion)
        } else {
            updateCurrentTransaction(completion: completion)
        }
    }

    private func addNewTransaction(completion: @escaping (Result<Void, TransactionError>) -> Void) {
        dataStore.transactions(forAccount: account).addTransaction(
                        withCategory: category,
                        date: date,
                        amount: amount) { result in
            switch result {
            case .success: self.saveCallback?()
            case .failure(let e): completion(.failure(e))
            }
        }
    }

    private func updateCurrentTransaction(completion: @escaping (Result<Void, TransactionError>) -> Void) {
        guard var transaction = self.transaction else { return }
        transaction.category = category
        transaction.date = date
        transaction.amount = amount

        dataStore.transactions(forAccount: account).update(transaction: transaction) { result in
            switch result {
            case .success: self.saveCallback?()
            case .failure(let e): completion(.failure(e))
            }
        }
    }
}
