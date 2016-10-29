//
//  Created by Félix Simões on 28/10/16.
//
//

import Foundation

class AccountsListViewModel {
    private let dataProvider: AccountsDataProvider
    private var accounts: [Account] = []

    init(accountsDataProvider: AccountsDataProvider) {
        dataProvider = accountsDataProvider
    }

    var numberOfAccounts: Int {
        return accounts.count
    }

    func account(at index: Int) -> Account? {
        guard index < numberOfAccounts else { return nil }
        return accounts[index]
    }

    var selectAccountCallback: ((Account) -> Void)?
    func selectAccount(at index: Int) {
        guard index < numberOfAccounts else { return }
        selectAccountCallback?(accounts[index])
    }

    func reloadData(completion: @escaping (Result<Void, AccountError>) -> Void) {
        dataProvider.allAccounts { result in
            switch result {
            case .success(let accounts):
                self.accounts = accounts
                completion(.success())
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
