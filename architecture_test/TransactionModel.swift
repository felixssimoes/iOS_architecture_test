//
//  TransactionModel.swift
//  architecture_test
//
//  Created by Felix Simoes on 30/10/2016.
//
//

import Foundation

enum TransactionError: Error {
    case invalidAmount
    case invalidDate
    case invalidCategory
    case transactionNotFound
    case other
}

protocol TransactionModel {
    var account: AccountModel { get }
    var id: String { get }
    var category: String { get }
    var date: Date { get }
    var amount: Decimal { get }
}


protocol TransactionsDataSource {
    func all(forAccount: AccountModel) throws -> [TransactionModel]
    func newTransaction(forAccount: AccountModel) throws -> TransactionModel
    func add(transaction: TransactionModel) throws
    func update(transaction: TransactionModel) throws
    func delete(transaction: TransactionModel) throws
}
