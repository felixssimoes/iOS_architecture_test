//
//  Created by Félix Simões on 28/10/16.
//
//

import Foundation

class AccountDetailViewModel {
    private let dataProvider: AccountsDataProvider
    private var account: Account?

    var name: String

    init(account: Account?, accountsDataProvider: AccountsDataProvider) {
        self.dataProvider = accountsDataProvider
        self.account = account
        self.name = account?.name ?? ""
    }

    var saveCallback: (() -> Void)?
    func saveAccount(completion: @escaping (Result<Void, AccountError>) -> Void) {
        if var account = account {
            account.name = name
            dataProvider.update(account: account) { result in
                switch result {
                case .success: self.saveCallback?()
                case .failure(let error): completion(.failure(error))
                }
            }
        } else {
            dataProvider.addAccount(withName: name) { result in
                switch result {
                case .success: self.saveCallback?()
                case .failure(let error): completion(.failure(error))
                }
            }
        }

    }

    var cancelCallback: (() -> Void)?
    func cancel() {
        cancelCallback?()
    }
}
