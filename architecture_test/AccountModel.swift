//
//  Created by Félix Simões on 28/10/16.
//
//

import Foundation
import RxSwift

enum AccountError: Error {
    case invalidName
    case accountNotFound
    case other
}

struct AccountModel {
    let id: String
    var name: String
}

protocol AccountsDataStore {
    func all() throws -> [AccountModel]
    func newAccount() throws -> AccountModel
    func add(account: AccountModel) throws
    func update(account: AccountModel) throws
    func delete(account: AccountModel) throws
}

protocol ReactiveAccountsDataSource {
    func allAccounts() -> Observable<[AccountModel]>
    func addAccount(withName: String) -> Observable<AccountModel>
    func update(account: AccountModel) -> Observable<Void>
    func delete(account: AccountModel) -> Observable<Void>
}
