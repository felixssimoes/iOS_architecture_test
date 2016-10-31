//
//  Created by Félix Simões on 28/10/16.
//
//

import Foundation

enum AccountError: Error {
    case invalidName
    case accountNotFound
    case other
}

protocol AccountModel {
    var id: String { get }
    var name: String { get set }
}

protocol AccountsDataSource {
    func all() throws -> [AccountModel]
    func newAccount() throws -> AccountModel
    func add(account: AccountModel) throws
    func update(account: AccountModel) throws
    func delete(account: AccountModel) throws
}
