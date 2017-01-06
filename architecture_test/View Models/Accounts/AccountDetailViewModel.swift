//
//  Created by Félix Simões on 28/10/16.
//
//

import Foundation

class AccountDetailViewModel {
    private let dataProvider: AccountsDataSource
    private var account: AccountModel?

    var name: String

    init(account: AccountModel?, accountsDataProvider: AccountsDataSource) {
        self.dataProvider = accountsDataProvider
        self.account = account
        self.name = account?.name ?? ""
    }

    var saveCallback: (() -> Void)?
    func saveAccount(completion: @escaping (Result<Void, AccountError>) -> Void) {
        if var account = account {
            account.name = name
            dataProvider.update(account: account, completion: completion)
        } else {
            dataProvider.addAccount(withName: name) { result in
                switch result {
                case .success: completion(.success())
                case .failure(let error): completion(.failure(error))
                }
            }
        }

    }
}
