//
//  Created by Félix Simões on 28/10/16.
//
//

import Foundation

final class LocalAccountsDataSource: AccountsDataSource {
    private let dataStore: DataStore

    init(dataStore: DataStore) {
        self.dataStore = dataStore
    }

    func allAccounts(completion: @escaping (Result<[AccountModel], AccountError>) -> Void) {
        do {
            let accounts = try dataStore.accounts().all()
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
            var newAccount = try dataStore.accounts().newAccount()
            newAccount.name = name
            try dataStore.accounts().add(account: newAccount)
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
            try dataStore.accounts().update(account: account)
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
            try dataStore.accounts().delete(account: account)
            completion(.success())
        } catch(let error as AccountError) {
            completion(.failure(error))
        }
        catch {
            completion(.failure(.other))
        }
    }
}
