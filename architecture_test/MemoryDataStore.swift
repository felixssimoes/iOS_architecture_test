//
// Created by Felix Simoes on 31/10/2016.
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
