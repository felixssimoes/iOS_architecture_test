//
//  TransactionsListViewController.swift
//  architecture_test
//
//  Created by Felix Simoes on 31/10/2016.
//
//

import Foundation
import UIKit

class TransactionsListViewController: UITableViewController {
    var viewModel: TransactionsListViewModel!
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.title
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.reloadData { result in
            switch result {
            case .success: self.tableView.reloadData()
            case .failure(let e): print(e)
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func didSelectAddButton() {
        viewModel.newTransaction()
        tableView.reloadData()
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
}
