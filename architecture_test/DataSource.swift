//
// Created by Felix Simoes on 01/11/2016.
//

import Foundation

protocol DataSource {
    func transactions(forAccount: AccountModel) -> TransactionsDataSource
    func reactiveAccounts() -> ReactiveAccountsDataSource
}
