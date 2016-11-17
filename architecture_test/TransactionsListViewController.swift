//
//  TransactionsListViewController.swift
//  architecture_test
//
//  Created by Felix Simoes on 31/10/2016.
//
//

import Foundation
import UIKit
import RxSwift

struct TransactionsListNavigation {
    var onNewTransaction: (() -> Void)?
    var onSelectTransaction: ((TransactionModel) -> Void)?
}

class TransactionsListViewController: UITableViewController {
    var viewModel: TransactionsListViewModel!
    var navigation: TransactionsListNavigation?
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.title
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.reloadData()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { _ in
                self.tableView.reloadData()
            }, onError: { error in
                print(error)
            }).dispose()
    }

    // MARK: - Actions
    
    @IBAction func didSelectAddButton() {
        navigation?.onNewTransaction?()
    }
    
    // MARK: - Table view
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfTransactions
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionsListCell", for: indexPath)
        if let t = viewModel.transaction(at: indexPath.row) {
            cell.textLabel?.text = "\(t.category):\(t.amount)"
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let t = viewModel.transaction(at: indexPath.row) {
            navigation?.onSelectTransaction?(t)
        }
    }

}
