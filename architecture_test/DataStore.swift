//
//  DataStore.swift
//  architecture_test
//
//  Created by Felix Simoes on 29/10/2016.
//
//

import Foundation

protocol DataStore {
    func accounts() -> AccountsDataProvider
}
