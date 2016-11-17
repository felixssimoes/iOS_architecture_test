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

    func reactiveSaveAccount() -> Observable<Void> {
        if var account = account {
            account.name = name
            return dataSource.reactiveAccounts().update(account: account)
        } else {
            return dataSource.reactiveAccounts().addAccount(withName: name).flatMap { account -> Observable<Void> in
                return Observable.just()
            }
        }
    }
}
