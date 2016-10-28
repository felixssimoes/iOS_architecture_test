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

protocol AccountModel {
    var id: String { get }
    var name: String { get }
}

protocol AccountsDataSource {
    func all(completion: @escaping (Result<[AccountModel], AccountError>) -> Void)
    func newAccount(completion: @escaping (Result<AccountModel, AccountError>) -> Void)
    func add(account: AccountModel, completion: (Result<Void, AccountError>) -> Void)
    func update(account: AccountModel, completion: (Result<Void, AccountError>) -> Void)
    func delete(account: AccountModel, completion: (Result<Void, AccountError>) -> Void)
}
