//
// Created by Felix Simoes on 01/11/2016.
//

import Foundation

protocol DataStore {
    func accounts() -> AccountsDataProvider
    func transactions(forAccount: AccountModel) -> TransactionsDataProvider
}