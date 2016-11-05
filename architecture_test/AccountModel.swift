//
//  Created by Félix Simões on 28/10/16.
//
//

import Foundation

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

protocol AccountsDataSource {
    func allAccounts(completion: @escaping (Result<[AccountModel], AccountError>) -> Void)
    func addAccount(withName name: String, completion: @escaping (Result<AccountModel, AccountError>) -> Void)
    func update(account: AccountModel, completion: @escaping (Result<Void, AccountError>) -> Void)
    func deleteAccount(account: AccountModel, completion: @escaping (Result<Void, AccountError>) -> Void)
}
