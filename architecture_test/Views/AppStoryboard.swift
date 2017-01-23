//
// Created by Felix Simoes on 23/01/2017.
//

import Foundation
import UIKit

enum AppStoryboard {
    case accounts, transactions, editors

    var name: String {
        switch self {
        case .accounts: return "Accounts"
        case .transactions: return "Transactions"
        case .editors: return "Editors"
        }
    }

    var instance: UIStoryboard {
        return UIStoryboard(name: name, bundle: nil)
    }
}
