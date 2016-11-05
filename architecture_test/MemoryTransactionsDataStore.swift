//
// Created by Felix Simoes on 31/10/2016.
//

import Foundation

private class MemoryTransaction {
    let id: String
    let account: AccountModel
    let accountId: String
    var category: String
    var date: Date
    var amount: Decimal

    init(transactionModel model: TransactionModel) {
        id = UUID().uuidString
        account = model.account
        accountId = account.id
        category = model.category
        date = model.date
        amount = model.amount
    }

    init(accountModel: AccountModel) {
        id = UUID().uuidString
        account = accountModel
        accountId = account.id
        category = ""
        date = Date()
        amount = 0
    }

    func transactionModel() -> TransactionModel {
        return TransactionModel(id: id, account: account, category: category, date: date, amount: amount)
    }
}

private var transactions: [MemoryTransaction] = []

final class MemoryTransactionsDataStore: TransactionsDataStore {

    init(account: AccountModel) {

        let t1 = MemoryTransaction(accountModel: account); t1.category = "Category 1"; t1.amount = 11
        let t2 = MemoryTransaction(accountModel: account); t2.category = "Category 1"; t2.amount = 22
        let t3 = MemoryTransaction(accountModel: account); t3.category = "Category 2"; t3.amount = 33

        transactions = [t1, t2, t3]
    }

    init() {
    }

    func all(forAccount account: AccountModel) throws -> [TransactionModel] {
        return transactions.filter { $0.accountId == account.id } .map { $0.transactionModel() }
    }

    func newTransaction(forAccount account: AccountModel) throws -> TransactionModel {
        return MemoryTransaction(accountModel: account).transactionModel()
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
