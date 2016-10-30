//
//  Created by Félix Simões on 28/10/16.
//
//

import Foundation

class MemoryDataStore: DataStore {
    private let accountsDataProvider: AccountsDataProvider
    
    init() {
        let accountsDataSource = MemoryAccountsDataSource()
        accountsDataProvider = AccountsDataProvider(accountsDataSource: accountsDataSource)
    }
    
    func accounts() -> AccountsDataProvider {
        return accountsDataProvider
    }
    
    func transactions(forAccount account: AccountModel) -> TransactionsDataProvider {
        let transactionsDataSource = MemoryTransactionsDataSource(account: account)
        return TransactionsDataProvider(account: account, transactionsDataSource: transactionsDataSource)
    }
}

private class MemoryAccount: AccountModel {
    fileprivate (set) var name: String
    let id: String

    init() {
        id = UUID().uuidString
        name = ""
    }

    init(accountModel model: AccountModel) {
        id = UUID().uuidString
        name = model.name
    }
}

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

final class MemoryAccountsDataSource: AccountsDataSource {
    private var accounts: [MemoryAccount] = []

    init() {
        let a1 = MemoryAccount(); a1.name = "Account 1"
        let a2 = MemoryAccount(); a2.name = "Account 2"
        accounts = [a1, a2]
    }

    func all() throws -> [AccountModel] {
        return accounts
    }

    func newAccount() throws -> AccountModel {
        return MemoryAccount()
    }

    func add(account: AccountModel) throws {
        let newAccount = MemoryAccount(accountModel: account)
        accounts.append(newAccount)
    }

    func update(account: AccountModel) throws {
        guard let existingAccount = findAccount(withId: account.id) else {
            throw AccountError.accountNotFound
        }
        existingAccount.name = account.name
    }

    func delete(account: AccountModel) throws {
        guard let existingAccount = findAccount(withId: account.id) else {
            throw AccountError.accountNotFound
        }
        accounts = accounts.filter { $0.id != existingAccount.id }
    }

    private func findAccount(withId id: String) -> MemoryAccount? {
        return accounts.first { $0.id == id }
    }
}

final class MemoryTransactionsDataSource: TransactionsDataSource {
    private var transactions: [MemoryTransaction] = []
    private let account: AccountModel
    
    fileprivate init(account: AccountModel) {
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
