//
//  TransactionModel.swift
//  architecture_test
//
//  Created by Felix Simoes on 30/10/2016.
//
//

import Foundation
import RxSwift

enum TransactionError: Error {
    case invalidAmount
    case invalidDate
    case invalidCategory
    case transactionNotFound
    case accountNotFound
    case other
}

struct TransactionModel {
    let id: String
    let account: AccountModel
    var category: String
    var date: Date
    var amount: Decimal
}


protocol TransactionsDataStore {
    func all(forAccount: AccountModel) throws -> [TransactionModel]
    func newTransaction(forAccount: AccountModel) throws -> TransactionModel
    func add(transaction: TransactionModel) throws
    func update(transaction: TransactionModel) throws
    func delete(transaction: TransactionModel) throws
}

protocol TransactionsDataSource {
    func allTransactions() -> Observable<[TransactionModel]>
    func addTransaction(withCategory: String, date: Date, amount: Decimal) -> Observable<TransactionModel>
    func update(transaction: TransactionModel) -> Observable<Void>
    func delete(transaction: TransactionModel) -> Observable<Void>
}
