//
// Created by Felix Simoes on 01/11/2016.
//

import Foundation

protocol DataSource {
    func accounts() -> AccountsDataSource
    func transactions(forAccount: AccountModel) -> TransactionsDataSource
}
