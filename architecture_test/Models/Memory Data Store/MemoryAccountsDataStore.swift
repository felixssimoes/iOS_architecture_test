//
//  Created by Félix Simões on 28/10/16.
//
//

import Foundation

private class MemoryAccount {
    var name: String
    let id: String

    init() {
        id = UUID().uuidString
        name = ""
    }

    init(accountModel model: AccountModel) {
        id = UUID().uuidString
        name = model.name
    }
    
    func accountModel() -> AccountModel {
        return AccountModel(id: id, name: name)
    }
}

final class MemoryAccountsDataStore: AccountsDataStore {
    private var accounts: [MemoryAccount] = []

    init() {
        let a1 = MemoryAccount(); a1.name = "Account 1"
        let a2 = MemoryAccount(); a2.name = "Account 2"
        accounts = [a1, a2]
    }

    func all() throws -> [AccountModel] {
        return accounts.map { $0.accountModel() }
    }

    func newAccount() throws -> AccountModel {
        return MemoryAccount().accountModel()
    }

    func add(account: AccountModel) throws {
        let newAccount = MemoryAccount(accountModel: account)
        accounts.append(newAccount)
    }

    func update(account: AccountModel) throws {
        guard let existingAccount = findAccount(withId: account.id) else {
            throw AccountError.accountNotFound
        }
        existingAccount.name = account.name
    }

    func delete(account: AccountModel) throws {
        guard let existingAccount = findAccount(withId: account.id) else {
            throw AccountError.accountNotFound
        }
        accounts = accounts.filter { $0.id != existingAccount.id }
    }

    private func findAccount(withId id: String) -> MemoryAccount? {
        return accounts.first { $0.id == id }
    }
}
