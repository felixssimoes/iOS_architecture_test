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
    private let dataSource: DataSource

    private var navigationController: UINavigationController?
    private var accountsCoordinator: AccountsCoordinator?

    init(window: UIWindow) {
        self.window = window
//        dataSource = MemoryDataSource()
        dataSource = RealmDataSource()
    }

    func start() {
        navigationController = UINavigationController()
        window.rootViewController = navigationController
        
        accountsCoordinator = AccountsCoordinator(navigationController: navigationController!, dataSource: dataSource)
        accountsCoordinator?.start()
    }
}
