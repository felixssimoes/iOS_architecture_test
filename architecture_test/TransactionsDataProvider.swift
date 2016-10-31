//
//  TransactionsDataProvider.swift
//  architecture_test
//
//  Created by Felix Simoes on 30/10/2016.
//
//

import Foundation

class TransactionsDataProvider {
    private let dataSource: TransactionsDataSource
    private let account: AccountModel
    
    init(account: AccountModel, transactionsDataSource: TransactionsDataSource) {
        self.account = account
        self.dataSource = transactionsDataSource
    }
    
    func allTransactions(completion: @escaping (Result<[TransactionModel], TransactionError>) -> Void) {
        do {
            let transactions = try dataSource.all(forAccount: account)
            completion(.success(transactions))
        } catch(let e as TransactionError) {
            completion(.failure(e))
        } catch {
            completion(.failure(.other))
        }
    }
    
    func addTransaction(withCategory category: String, date: Date, amount: Decimal, completion: @escaping (Result<TransactionModel, TransactionError>) -> Void) {
        guard !category.isEmpty else {
            completion(.failure(.invalidCategory))
            return
        }
        guard amount > 0 else {
            completion(.failure(.invalidAmount))
            return
        }
        
        do {
            var transaction = try dataSource.newTransaction(forAccount: account)
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
    
    func update(transaction: TransactionModel, completion: @escaping (Result<Void, TransactionError>) -> Void) {
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
    
    func delete(transaction: TransactionModel, completion: @escaping (Result<Void, TransactionError>) -> Void) {
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
