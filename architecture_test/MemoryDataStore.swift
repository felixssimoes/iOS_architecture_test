//
// Created by Felix Simoes on 31/10/2016.
//

import Foundation

class MemoryDataStore: DataStore {
    private let accountsDataSource: AccountsDataStore
    private let transactionsDataSource: TransactionsDataStore

    init() {
        accountsDataSource = MemoryAccountsDataStore()
        transactionsDataSource = MemoryTransactionsDataStore()
    }

    func accounts() -> AccountsDataStore {
        return accountsDataSource
    }

    func transactions() -> TransactionsDataStore {
        return transactionsDataSource
    }
}

class MemoryDataSource: DataSource {
    let dataSource = MemoryDataStore()

    func transactions(forAccount account: AccountModel) -> TransactionsDataSource {
        return LocalTransactionsDataSource(account: account, dataStore: dataSource)
    }

    func reactiveAccounts() -> ReactiveAccountsDataSource {
        return LocalReactiveAccountsDataSource(dataStore: dataSource)
    }
}
