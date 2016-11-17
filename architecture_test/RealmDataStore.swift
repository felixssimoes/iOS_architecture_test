//
// Created by Felix Simoes on 04/11/2016.
//

import Foundation
import RealmSwift

class RealmDataStore: DataStore {
    private let realm: Realm

    init() {
        realm = try! Realm()
        print("realm db @ '\(realm.configuration.fileURL)'")
    }

    func accounts() -> AccountsDataStore {
        return RealmAccountsDataStore(realm: realm)
    }

    func transactions() -> TransactionsDataStore {
        return RealmTransactionsDataStore(realm: realm)
//        return MemoryTransactionsDataStore()
    }
}

class RealmDataSource: DataSource {
    private let dataStore = RealmDataStore()

    func transactions(forAccount account: AccountModel) -> TransactionsDataSource {
        return LocalTransactionsDataSource(account: account, dataStore: dataStore)
    }

    func accounts() -> AccountsDataSource {
        return LocalAccountsDataSource(dataStore: dataStore)
    }
}
