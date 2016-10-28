//
//  Created by Félix Simões on 28/10/16.
//
//

import Foundation

private class MemoryAccount: AccountModel {
    fileprivate (set) var name: String
    let id: String

    init() {
        id = UUID().uuidString
        name = ""
    }

    init(accountModel model: AccountModel) {
        id = UUID().uuidString
        name = model.name
    }
}

final class MemoryAccountsDataSource: AccountsDataSource {
    private var accounts: [MemoryAccount] = []

    init() {
        let a1 = MemoryAccount(); a1.name = "Account 1"
        let a2 = MemoryAccount(); a2.name = "Account 2"
        accounts = [a1, a2]
    }

    func all(completion: @escaping (Result<[AccountModel], AccountError>) -> Void) {
        completion(.success(accounts))
    }

    func newAccount(completion: @escaping (Result<AccountModel, AccountError>) -> Void) {
        let account = MemoryAccount()
        completion(.success(account))
    }

    func add(account: AccountModel, completion: (Result<Void, AccountError>) -> Void) {
        let newAccount = MemoryAccount(accountModel: account)
        accounts.append(newAccount)
        completion(.success())
    }

    func update(account: AccountModel, completion: (Result<Void, AccountError>) -> Void) {
        guard let existingAccount = findAccount(withId: account.id) else {
            completion(.failure(.accountNotFound))
            return
        }
        existingAccount.name = account.name
        completion(.success())
    }

    func delete(account: AccountModel, completion: (Result<Void, AccountError>) -> Void) {
        guard let existingAccount = findAccount(withId: account.id) else {
            completion(.failure(.accountNotFound))
            return
        }
        accounts = accounts.filter { $0.id != existingAccount.id }
        completion(.success())
    }

    private func findAccount(withId id: String) -> MemoryAccount? {
        return accounts.first { $0.id == id }
    }
}
