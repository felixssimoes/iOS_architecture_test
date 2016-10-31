//
// Created by Felix Simoes on 31/10/2016.
//

import Foundation

class MemoryDataSource: DataSource {
    private let accountsDataSource: AccountsDataSource
    private let transactionsDataSource: TransactionsDataSource

    init() {
        accountsDataSource = MemoryAccountsDataSource()
        transactionsDataSource = MemoryTransactionsDataSource()
    }

    func accounts() -> AccountsDataSource {
        return accountsDataSource
    }

    func transactions() -> TransactionsDataSource {
        return transactionsDataSource
    }
}

class MemoryDataStore: DataStore {
    let dataSource = MemoryDataSource()

    func accounts() -> AccountsDataProvider {
        return AccountsDataProvider(dataSource: dataSource)
    }

    func transactions(forAccount account: AccountModel) -> TransactionsDataProvider {
        return TransactionsDataProvider(account: account, dataSource: dataSource)
    }
}