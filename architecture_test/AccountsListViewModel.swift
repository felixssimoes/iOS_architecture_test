//
//  Created by Félix Simões on 28/10/16.
//
//

import Foundation

class AccountsListViewModel {
    private let dataProvider: AccountsDataSource
    private var accounts: [AccountModel] = []

    init(accountsDataProvider: AccountsDataSource) {
        dataProvider = accountsDataProvider
    }

    var numberOfAccounts: Int {
        return accounts.count
    }

    func account(at index: Int) -> AccountModel? {
        guard index < numberOfAccounts else { return nil }
        return accounts[index]
    }

    var selectAccountCallback: ((AccountModel) -> Void)?
    func selectAccount(at index: Int) {
        guard index < numberOfAccounts else { return }
        selectAccountCallback?(accounts[index])
    }
    
    var selectAccountDetailCallback: ((AccountModel) -> Void)?
    func selectAccountDetail(at index: Int) {
        guard index < numberOfAccounts else { return }
        selectAccountDetailCallback?(accounts[index])
    }
    
    var addAccountCallback: (() -> Void)?
    func addAccount() {
        addAccountCallback?()
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
