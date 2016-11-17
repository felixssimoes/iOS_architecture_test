//
//  Created by Félix Simões on 28/10/16.
//
//

import Foundation
import RxSwift

class AccountsListViewModel {
    private let dataSource: DataSource
    private var accounts: [AccountModel] = []

    init(dataSource: DataSource) {
        self.dataSource = dataSource
    }

    var numberOfAccounts: Int {
        return accounts.count
    }

    func account(at index: Int) -> AccountModel? {
        guard index < numberOfAccounts else { return nil }
        return accounts[index]
    }

    func reloadData() -> Observable<Void> {
        return dataSource.accounts().allAccounts()
            .flatMap { accounts -> Observable<Void> in
                self.accounts = accounts
                return Observable.just()
            }
    }
}
