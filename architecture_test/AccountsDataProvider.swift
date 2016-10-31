//
//  Created by Félix Simões on 28/10/16.
//
//

import Foundation

final class AccountsDataProvider {
    private let dataSource: DataSource

    init(dataSource: DataSource) {
        self.dataSource = dataSource
    }

    func allAccounts(completion: @escaping (Result<[AccountModel], AccountError>) -> Void) {
        do {
            let accounts = try dataSource.accounts().all()
            completion(.success(accounts))
        } catch(let error as AccountError) {
            completion(.failure(error))
        }
        catch {
            completion(.failure(.other))
        }
    }

    func addAccount(withName name: String, completion: @escaping (Result<AccountModel, AccountError>) -> Void) {
        guard !name.isEmpty else {
            completion(.failure(.invalidName))
            return
        }

        do {
            var newAccount = try dataSource.accounts().newAccount()
            newAccount.name = name
            try dataSource.accounts().add(account: newAccount)
            completion(.success(newAccount))

        } catch(let error as AccountError) {
            completion(.failure(error))
        }
        catch {
            completion(.failure(.other))
        }
    }

    func update(account: AccountModel, completion: @escaping (Result<Void, AccountError>) -> Void) {
        guard !account.name.isEmpty else {
            completion(.failure(.invalidName))
            return
        }

        do {
            try dataSource.accounts().update(account: account)
            completion(.success())
        } catch(let error as AccountError) {
            completion(.failure(error))
        }
        catch {
            completion(.failure(.other))
        }
    }

    func deleteAccount(account: AccountModel, completion: @escaping (Result<Void, AccountError>) -> Void) {
        do {
            try dataSource.accounts().delete(account: account)
            completion(.success())
        } catch(let error as AccountError) {
            completion(.failure(error))
        }
        catch {
            completion(.failure(.other))
        }
    }
}
