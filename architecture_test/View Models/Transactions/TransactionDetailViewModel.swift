//
// Created by Felix Simoes on 01/11/2016.
//

import Foundation

class TransactionDetailViewModel {
    private let dataSource: DataSource
    private let account: AccountModel
    private var transaction: TransactionModel? {
        didSet {
            self.category = transaction?.category ?? ""
            self.date = transaction?.date ?? Date()
            self.amount = transaction?.amount ?? 0
        }
    }

    var category: String = ""
    var date: Date = Date()
    var amount: Decimal = 0

    init(transaction: TransactionModel, dataStore: DataSource) {
        self.dataSource = dataStore
        self.transaction = transaction
        self.account = transaction.account
    }

    init(account: AccountModel, dataStore: DataSource) {
        self.dataSource = dataStore
        self.transaction = nil
        self.account = account
    }

    func save(completion: @escaping (Result<Void, TransactionError>) -> Void) {
        if transaction == nil {
            addNewTransaction(completion: completion)
        } else {
            updateCurrentTransaction(completion: completion)
        }
    }

    private func addNewTransaction(completion: @escaping (Result<Void, TransactionError>) -> Void) {
        dataSource.transactions(forAccount: account).addTransaction(
                        withCategory: category,
                        date: date,
                        amount: amount) { result in
            switch result {
            case .success(let newTransaction):
                self.transaction = newTransaction
                completion(.success())
            case .failure(let e): completion(.failure(e))
            }
        }
    }

    private func updateCurrentTransaction(completion: @escaping (Result<Void, TransactionError>) -> Void) {
        guard var transaction = self.transaction else { return }
        transaction.category = category
        transaction.date = date
        transaction.amount = amount

        dataSource.transactions(forAccount: account).update(transaction: transaction, completion: completion)
    }
}
