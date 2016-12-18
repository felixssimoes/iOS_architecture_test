//
// Created by Felix Simoes on 04/11/2016.
//

import Foundation
import RealmSwift

class RealmTransactionObject: Object {
    dynamic var id = UUID().uuidString
    dynamic var account: RealmAccountObject?
    dynamic var category = ""
    dynamic var date = Date()
    dynamic var amount: String = ""

    static func object(fromModel model: TransactionModel, accountObject: RealmAccountObject) -> RealmTransactionObject {
        let t = RealmTransactionObject()
        t.id = model.id
        t.account = accountObject
        t.category = model.category
        t.date = model.date
        t.amount = String(describing: model.amount)
        
        return t
    }
}

extension TransactionModel {
    init(transactionObject object: RealmTransactionObject) {
        id = object.id
        account = AccountModel(realmAccountObject: object.account!)
        category = object.category
        date = object.date
        amount = Decimal(string: object.amount) ?? 0
    }
}

class RealmTransactionsDataStore: TransactionsDataStore {
    private let realm: Realm

    init(realm: Realm) {
        self.realm = realm
    }

    func all(forAccount account: AccountModel) throws -> [TransactionModel] {
        guard let accountObject = findAccountObject(fromModel: account) else { throw TransactionError.other }
        return Array(accountObject.transactions).map { TransactionModel(transactionObject: $0) }
    }

    func newTransaction(forAccount account: AccountModel) throws -> TransactionModel {
        guard let accountObject = findAccountObject(fromModel: account) else { throw TransactionError.accountNotFound }
        let transaction = RealmTransactionObject()
        transaction.account = accountObject
        return TransactionModel(transactionObject: transaction)
    }

    func add(transaction: TransactionModel) throws {
        guard let accountObject = findAccountObject(fromModel: transaction.account) else { throw TransactionError.accountNotFound }
        let object = RealmTransactionObject.object(fromModel: transaction, accountObject: accountObject)
        try realm.write {
            realm.add(object)
            accountObject.transactions.append(object)
        }
    }

    func update(transaction: TransactionModel) throws {
        guard let object = findTransactionObject(fromModel: transaction) else { throw TransactionError.other }
        try realm.write {
            object.category = transaction.category
            object.date = transaction.date
            object.amount = String(describing: transaction.amount)
        }
    }

    func delete(transaction: TransactionModel) throws {
        guard let object = findTransactionObject(fromModel: transaction) else { throw TransactionError.other }
        try realm.write {
            realm.delete(object)
        }
    }

    private func findTransactionObject(fromModel model: TransactionModel) -> RealmTransactionObject? {
        return realm.objects(RealmTransactionObject.self).filter("id == '\(model.id)'").first
    }
    
    private func findAccountObject(fromModel model: AccountModel) -> RealmAccountObject? {
        return realm.objects(RealmAccountObject.self).filter("id == '\(model.id)'").first
    }
}
