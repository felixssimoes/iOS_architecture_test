//
//  Created by Felix Simoes on 29/10/2016.
//
//

import Foundation

protocol DataStore {
    func accounts() -> AccountsDataStore
    func transactions() -> TransactionsDataStore
}
