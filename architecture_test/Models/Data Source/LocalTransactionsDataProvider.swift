//
//  Created by Felix Simoes on 30/10/2016.
//
//

import Foundation

class LocalTransactionsDataSource: TransactionsDataSource {
    private let dataStore: DataStore
    private let account: AccountModel
    
    init(account: AccountModel, dataStore: DataStore) {
        self.account = account
        self.dataStore = dataStore
    }
    
    func allTransactions(completion: @escaping (Result<[TransactionModel], TransactionError>) -> Void) {
        do {
            let transactions = try dataStore.transactions().all(forAccount: account)
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
            var transaction = try dataStore.transactions().newTransaction(forAccount: account)
            transaction.category = category
            transaction.date = date
            transaction.amount = amount
            
            try dataStore.transactions().add(transaction: transaction)
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
            try dataStore.transactions().update(transaction: transaction)
            completion(.success())
            
        } catch(let e as TransactionError) {
            completion(.failure(e))
        } catch {
            completion(.failure(.other))
        }
    }
    
    func delete(transaction: TransactionModel, completion: @escaping (Result<Void, TransactionError>) -> Void) {
        do {
            try dataStore.transactions().delete(transaction: transaction)
            completion(.success())
            
        } catch(let e as TransactionError) {
            completion(.failure(e))
        } catch {
            completion(.failure(.other))
        }
        
    }
}
