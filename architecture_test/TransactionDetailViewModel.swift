//
// Created by Felix Simoes on 01/11/2016.
//

import Foundation
import RxSwift

class TransactionDetailViewModel {
    private let dataSource: DataSource
    private let account: AccountModel
    private var transaction: TransactionModel? {
        didSet {
            self.category = transaction?.category ?? ""
            self.date = transaction?.date ?? Date()
            self.amount = transaction?.amount ?? 0
        }
    }

    var category: String = ""
    var date: Date = Date()
    var amount: Decimal = 0

    init(transaction: TransactionModel, dataStore: DataSource) {
        self.dataSource = dataStore
        self.transaction = transaction
        self.account = transaction.account

        self.category = transaction.category
        self.date = transaction.date
        self.amount = transaction.amount
    }

    init(account: AccountModel, dataStore: DataSource) {
        self.dataSource = dataStore
        self.transaction = nil
        self.account = account
    }

    func save() -> Observable<Void> {
        if transaction == nil {
            return addNewTransaction()
        } else {
            return updateCurrentTransaction()
        }
    }

    private func addNewTransaction() -> Observable<Void> {
        return dataSource.transactions(forAccount: account)
            .addTransaction(withCategory: category, date: date, amount: amount)
            .flatMap { transaction -> Observable<Void> in
                self.transaction = transaction
                return Observable.just()
        }
    }

    private func updateCurrentTransaction() -> Observable<Void> {
        guard var transaction = self.transaction else { return Observable.just() }

        transaction.category = category
        transaction.date = date
        transaction.amount = amount

        return dataSource.transactions(forAccount: account).update(transaction: transaction)
    }
}
