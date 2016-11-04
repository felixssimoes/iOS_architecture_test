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
    var category: String { get set }
    var date: Date { get set }
    var amount: Decimal { get set }
}


protocol TransactionsDataStore {
    func all(forAccount: AccountModel) throws -> [TransactionModel]
    func newTransaction(forAccount: AccountModel) throws -> TransactionModel
    func add(transaction: TransactionModel) throws
    func update(transaction: TransactionModel) throws
    func delete(transaction: TransactionModel) throws
}

protocol TransactionsDataSource {
    func allTransactions(completion: @escaping (Result<[TransactionModel], TransactionError>) -> Void)
    func addTransaction(withCategory: String,
                        date: Date,
                        amount: Decimal,
                        completion: @escaping (Result<TransactionModel, TransactionError>) -> Void)
    func update(transaction: TransactionModel, completion: @escaping (Result<Void, TransactionError>) -> Void)
    func delete(transaction: TransactionModel, completion: @escaping (Result<Void, TransactionError>) -> Void)
}
