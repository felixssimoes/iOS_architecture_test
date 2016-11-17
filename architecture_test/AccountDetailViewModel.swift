//
//  Created by Félix Simões on 28/10/16.
//
//

import Foundation
import RxSwift

class AccountDetailViewModel {
    private let dataSource: DataSource
    private var account: AccountModel?

    var name: String

    init(account: AccountModel?, dataSource: DataSource) {
        self.dataSource = dataSource
        self.account = account
        self.name = account?.name ?? ""
    }

    var saveCallback: (() -> Void)?

    func saveAccount() -> Observable<Void> {
        if var account = account {
            account.name = name
            return dataSource.accounts().update(account: account)
        } else {
            return dataSource.accounts().addAccount(withName: name).flatMap { account -> Observable<Void> in
                return Observable.just()
            }
        }
    }
}
