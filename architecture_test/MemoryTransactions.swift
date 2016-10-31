//
// Created by Felix Simoes on 31/10/2016.
//

import Foundation

private class MemoryTransaction: TransactionModel {
    let id: String
    let account: AccountModel
    fileprivate (set) var category: String
    fileprivate (set) var date: Date
    fileprivate (set) var amount: Decimal

    init(transactionModel model: TransactionModel) {
        id = UUID().uuidString
        account = model.account
        category = model.category
        date = model.date
        amount = model.amount
    }

    init(accountModel: AccountModel) {
        id = UUID().uuidString
        account = accountModel
        category = ""
        date = Date()
        amount = 0
    }
}

final class MemoryTransactionsDataSource: TransactionsDataSource {
    private var transactions: [MemoryTransaction] = []
    private let account: AccountModel

    init(account: AccountModel) {
        self.account = account

        let t1 = MemoryTransaction(accountModel: account); t1.category = "Category 1"; t1.amount = 11
        let t2 = MemoryTransaction(accountModel: account); t2.category = "Category 1"; t2.amount = 22
        let t3 = MemoryTransaction(accountModel: account); t3.category = "Category 2"; t3.amount = 33

        transactions = [t1, t2, t3]
    }

    func all(forAccount: AccountModel) throws -> [TransactionModel] {
        return transactions
    }

    func newTransaction(forAccount account: AccountModel) throws -> TransactionModel {
        return MemoryTransaction(accountModel: account)
    }

    func add(transaction: TransactionModel) throws {
        transactions.append(MemoryTransaction(transactionModel: transaction))
    }

    func update(transaction: TransactionModel) throws {
        guard let existingTransaction = findTransaction(withId: transaction.id) else {
            throw TransactionError.transactionNotFound
        }
        existingTransaction.category = transaction.category
        existingTransaction.date = transaction.date
        existingTransaction.amount = transaction.amount
    }

    func delete(transaction: TransactionModel) throws {
        guard let existingTransaction = findTransaction(withId: transaction.id) else {
            throw TransactionError.transactionNotFound
        }
        transactions = transactions.filter { $0.id != existingTransaction.id }
    }

    private func findTransaction(withId id: String) -> MemoryTransaction? {
        return transactions.first { $0.id == id }
    }
}
