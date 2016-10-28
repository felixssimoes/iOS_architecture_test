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
        do {
            let accounts = try dataSource.all().map { Account(accountModel: $0) }
            completion(.success(accounts))
        } catch(let error as AccountError) {
            completion(.failure(error))
        }
        catch {
            completion(.failure(.other))
        }
    }

    func addAccount(withName name: String, completion: @escaping (Result<Account, AccountError>) -> Void) {
        guard !name.isEmpty else {
            completion(.failure(.invalidName))
            return
        }

        do {
            var newAccount = Account(accountModel: try dataSource.newAccount())
            newAccount.name = name
            try dataSource.update(account: newAccount)
            completion(.success(newAccount))

        } catch(let error as AccountError) {
            completion(.failure(error))
        }
        catch {
            completion(.failure(.other))
        }
    }

    func update(account: Account, completion: @escaping (Result<Void, AccountError>) -> Void) {
        do {
            try dataSource.update(account: account)
            completion(.success())
        } catch(let error as AccountError) {
            completion(.failure(error))
        }
        catch {
            completion(.failure(.other))
        }
    }

    func deleteAccount(account: Account, completion: @escaping (Result<Void, AccountError>) -> Void) {
        do {
            try dataSource.delete(account: account)
            completion(.success())
        } catch(let error as AccountError) {
            completion(.failure(error))
        }
        catch {
            completion(.failure(.other))
        }
    }
}
