//
// Created by Félix Simões on 17/11/16.
//

import Foundation
import RxSwift

class LocalAccountsDataSource {
    fileprivate let dataStore: DataStore

    init(dataStore: DataStore) {
        self.dataStore = dataStore
    }
}

extension LocalAccountsDataSource: AccountsDataSource {
    func allAccounts() -> Observable<[AccountModel]> {
        return Observable.create { observer in
            do {
                observer.onNext(try self.dataStore.accounts().all())
                observer.onCompleted()
            } catch (let error) {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }

    func addAccount(withName name: String) -> Observable<AccountModel> {
        if name.isEmpty {
            return Observable.error(AccountError.invalidName)
        }

        return Observable.create { observer in
            do {
                var account = try self.dataStore.accounts().newAccount()
                account.name = name
                try self.dataStore.accounts().add(account: account)
                observer.onNext(account)
                observer.onCompleted()
            } catch (let error) {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }

    func update(account: AccountModel) -> Observable<Void> {
        if account.name.isEmpty {
            return Observable.error(AccountError.invalidName)
        }

        return Observable.create { observer in
            do {
                try self.dataStore.accounts().update(account: account)
                observer.onNext()
                observer.onCompleted()
            } catch (let error) {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }

    func delete(account: AccountModel) -> Observable<Void> {
        return Observable.create { observer in
            do {
                try self.dataStore.accounts().delete(account: account)
                observer.onNext()
                observer.onCompleted()
            } catch (let error) {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
}
