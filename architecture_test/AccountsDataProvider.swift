//
//  Created by Félix Simões on 28/10/16.
//
//

import Foundation

struct Account: AccountModel {
    fileprivate let model: AccountModel

    var id: String {
        return model.id
    }

    var name: String

    init(accountModel: AccountModel) {
        model = accountModel
        name = model.name
    }
}

final class AccountsDataProvider {
    private let dataSource: AccountsDataSource

    init(accountsDataSource: AccountsDataSource) {
        dataSource = accountsDataSource
    }

    func allAccounts(completion: @escaping (Result<[Account], AccountError>) -> Void) {
        dataSource.all { result in
            switch result {
            case .success(let models):
                let accounts = models.map { Account(accountModel: $0) }
                completion(.success(accounts))

            case .failure(let error): completion(.failure(error))
            }
        }
    }

    func addAccount(withName name: String, completion: @escaping (Result<Account, AccountError>) -> Void) {
        guard !name.isEmpty else {
            completion(.failure(.invalidName))
            return
        }

        dataSource.newAccount { result in
            switch result {
            case .success(let account):
                var newAccount = Account(accountModel: account)
                newAccount.name = name
                self.dataSource.update(account: newAccount) { result in
                    switch result {
                    case .success: completion(.success(newAccount))
                    case .failure(let error): completion(.failure(error))
                    }
                }
            case .failure(let error): completion(.failure(error))
            }
        }
    }

    func update(account: Account, completion: @escaping (Result<Void, AccountError>) -> Void) {
        dataSource.update(account: account, completion: completion)
    }

    func deleteAccount(account: Account, completion: @escaping (Result<Void, AccountError>) -> Void) {
        dataSource.delete(account: account, completion: completion)
    }
}
