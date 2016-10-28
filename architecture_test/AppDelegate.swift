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

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let accountsDataSource = MemoryAccountsDataSource()
        let accountsDataProvider = AccountsDataProvider(accountsDataSource: accountsDataSource)

        let vc = AccountsListViewController()
        vc.viewModel = AccountsListViewModel(accountsDataProvider: accountsDataProvider)

        let nc = UINavigationController(rootViewController: vc)
        window.rootViewController = nc
    }
}
