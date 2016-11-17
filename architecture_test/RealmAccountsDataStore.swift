//
// Created by Felix Simoes on 04/11/2016.
//

import Foundation
import RealmSwift

class RealmAccountObject: Object {
    dynamic var id = UUID().uuidString
    dynamic var name = ""
    let transactions = List<RealmTransactionObject>()

    override static func primaryKey() -> String? {
        return "id"
    }

    static func objectFromModel(_ model: AccountModel) -> RealmAccountObject {
        let account = RealmAccountObject()
        account.id = model.id
        account.name = model.name
        return account
    }
}

extension AccountModel {
    init(realmAccountObject object: RealmAccountObject) {
        id = object.id
        name = object.name
    }
}

final class RealmAccountsDataStore: AccountsDataStore {
    private let realm: Realm

    init(realm: Realm) {
        self.realm = realm
    }

    func all() throws -> [AccountModel] {
        return Array(realm.objects(RealmAccountObject.self)).map { AccountModel(realmAccountObject: $0) }
    }

    func newAccount() throws -> AccountModel {
        return AccountModel(realmAccountObject: RealmAccountObject())
    }

    func add(account: AccountModel) throws {
        let object = RealmAccountObject.objectFromModel(account)
        try realm.write {
            realm.add(object)
        }
    }

    func update(account: AccountModel) throws {
        guard let object = findAccountObject(fromModel: account) else { throw AccountError.accountNotFound }
        try realm.write {
            object.name = account.name
        }
    }

    func delete(account: AccountModel) throws {
        guard let object = findAccountObject(fromModel: account) else { throw AccountError.accountNotFound }
        try realm.write {
            realm.delete(object)
        }
    }

    private func findAccountObject(fromModel model: AccountModel) -> RealmAccountObject? {
        return realm.objects(RealmAccountObject.self).filter("id == '\(model.id)'").first
    }
}
