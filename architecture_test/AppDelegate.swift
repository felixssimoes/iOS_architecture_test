//
//  AppDelegate.swift
//  architecture_test
//
//  Created by Félix Simões on 28/10/16.
//
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appSetup: AppSetup!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()

        appSetup = AppSetup(window: window!)
        appSetup.start()

        return true
    }
}

class AppSetup {
    private let window: UIWindow

    let accountsDataSource: MemoryAccountsDataSource
    let accountsDataProvider: AccountsDataProvider

    var navigationController: UINavigationController?

    init(window: UIWindow) {
        self.window = window

        accountsDataSource = MemoryAccountsDataSource()
        accountsDataProvider = AccountsDataProvider(accountsDataSource: accountsDataSource)
    }

    func start() {

        let vc = AccountsListViewController()
        vc.viewModel = AccountsListViewModel(accountsDataProvider: accountsDataProvider)
        vc.viewModel.selectAccountCallback = { account in
            self.showAccount(account)
        }

        navigationController = UINavigationController(rootViewController: vc)
        window.rootViewController = navigationController
    }

    func showAccount(_ account: Account) {
        let vc = AccountDetailViewController()
        let nc = UINavigationController(rootViewController: vc)

        vc.viewModel = AccountDetailViewModel(account: account, accountsDataProvider: accountsDataProvider)
        vc.viewModel.cancelCallback = {
            nc.dismiss(animated: true, completion: nil)
        }
        vc.viewModel.saveCallback = {
            nc.dismiss(animated: true, completion: nil)
        }

        navigationController?.present(nc, animated: true, completion: nil)
    }
}
