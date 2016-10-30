//
//  TransactionsDataProvider.swift
//  architecture_test
//
//  Created by Felix Simoes on 30/10/2016.
//
//

import Foundation

struct Transaction: TransactionModel {
    private (set) var id: String
    fileprivate (set) var account: AccountModel
    var category: String
    var date: Date
    var amount: Decimal
    
    init(transactionModel model: TransactionModel) {
        id = model.id
        account = model.account
        category = model.category
        date = model.date
        amount = model.amount
    }
}

class TransactionsDataProvider {
    private let dataSource: TransactionsDataSource
    private let account: AccountModel
    
    init(account: AccountModel, transactionsDataSource: TransactionsDataSource) {
        self.account = account
        self.dataSource = transactionsDataSource
    }
    
    func allTransactions(completion: @escaping (Result<[Transaction], TransactionError>) -> Void) {
        do {
            let transactions = try dataSource.all(forAccount: account).map { Transaction(transactionModel: $0) }
            completion(.success(transactions))
        } catch(let e as TransactionError) {
            completion(.failure(e))
        } catch {
            completion(.failure(.other))
        }
    }
    
    func addTransaction(withCategory category: String, date: Date, amount: Decimal, completion: @escaping (Result<Transaction, TransactionError>) -> Void) {
        guard !category.isEmpty else {
            completion(.failure(.invalidCategory))
            return
        }
        guard amount > 0 else {
            completion(.failure(.invalidAmount))
            return
        }
        
        do {
            var transaction = Transaction(transactionModel: try dataSource.newTransaction(forAccount: account))
            transaction.category = category
            transaction.date = date
            transaction.amount = amount
            
            try dataSource.add(transaction: transaction)
            completion(.success(transaction))
        
        } catch(let e as TransactionError) {
            completion(.failure(e))
        } catch {
            completion(.failure(.other))
        }
    }
    
    func update(transaction: Transaction, completion: @escaping (Result<Void, TransactionError>) -> Void) {
        guard !transaction.category.isEmpty else {
            completion(.failure(.invalidCategory))
            return
        }
        guard transaction.amount > 0 else {
            completion(.failure(.invalidAmount))
            return
        }
        
        do {
            try dataSource.update(transaction: transaction)
            completion(.success())
            
        } catch(let e as TransactionError) {
            completion(.failure(e))
        } catch {
            completion(.failure(.other))
        }
    }
    
    func delete(transaction: Transaction, completion: @escaping (Result<Void, TransactionError>) -> Void) {
        do {
            try dataSource.delete(transaction: transaction)
            completion(.success())
            
        } catch(let e as TransactionError) {
            completion(.failure(e))
        } catch {
            completion(.failure(.other))
        }
        
    }
}
