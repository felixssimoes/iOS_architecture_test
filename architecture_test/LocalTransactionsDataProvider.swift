//
//  Created by Felix Simoes on 30/10/2016.
//
//

import Foundation
import RxSwift

class LocalTransactionsDataSource: TransactionsDataSource {
    private let dataStore: DataStore
    private let account: AccountModel
    
    init(account: AccountModel, dataStore: DataStore) {
        self.account = account
        self.dataStore = dataStore
    }
    
    func allTransactions() -> Observable<[TransactionModel]> {
        return Observable.create { observer in
            do {
                observer.onNext(try self.dataStore.transactions().all(forAccount: self.account))
                observer.onCompleted()
            } catch(let e as TransactionError) {
                observer.onError(e)
            } catch {
                observer.onError(TransactionError.other)
            }
            return Disposables.create()
        }
    }

    func addTransaction(withCategory category: String, date: Date, amount: Decimal) -> Observable<TransactionModel> {
        guard !category.isEmpty else {
            return Observable.error(TransactionError.invalidCategory)
        }
        guard amount > 0 else {
            return Observable.error(TransactionError.invalidAmount)
        }
        
        return Observable.create { observer in
            do {
                var transaction = try self.dataStore.transactions().newTransaction(forAccount: self.account)
                transaction.category = category
                transaction.date = date
                transaction.amount = amount

                try self.dataStore.transactions().add(transaction: transaction)
                observer.onNext(transaction)
                observer.onCompleted()
            } catch(let e as TransactionError) {
                observer.onError(e)
            } catch {
                observer.onError(TransactionError.other)
            }
            return Disposables.create()
        }
    }
    
    func update(transaction: TransactionModel) -> Observable<Void> {
        guard !transaction.category.isEmpty else {
            return Observable.error(TransactionError.invalidCategory)
        }
        guard transaction.amount > 0 else {
            return Observable.error(TransactionError.invalidAmount)
        }

        return Observable.create { observer in
            do {
                try self.dataStore.transactions().update(transaction: transaction)
                observer.onNext()
                observer.onCompleted()
            } catch(let e as TransactionError) {
                observer.onError(e)
            } catch {
                observer.onError(TransactionError.other)
            }
            return Disposables.create()
        }
    }
    
    func delete(transaction: TransactionModel) -> Observable<Void> {
        return Observable.create { observer in
            do {
                try self.dataStore.transactions().delete(transaction: transaction)
                observer.onNext()
                observer.onCompleted()
            } catch(let e as TransactionError) {
                observer.onError(e)
            } catch {
                observer.onError(TransactionError.other)
            }
            return Disposables.create()
        }
    }
}
