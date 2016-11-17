//
// Created by Felix Simoes on 01/11/2016.
//

import Foundation
import UIKit
import RxSwift

struct TransactionDetailNavigation {
    var onSave:(() -> Void)?
    var onCancel:(() -> Void)?

    var onEditCategory: ((String) -> Void)?
    var onEditDate: ((Date) -> Void)?
    var onEditAmount: ((Decimal) -> Void)?
}

class TransactionDetailViewController: UITableViewController {

    private enum DetailSections: Int {
        case category = 0
        case date = 1
        case amount = 2

        var numberOfRows: Int {
            return 1
        }

        var cellIdentifier: String {
            switch self {
                case .category: return "CategoryCell"
                case .date:     return "DateCell"
                case .amount:   return "AmountCell"
            }
        }
    }

    var viewModel: TransactionDetailViewModel!
    var navigation: TransactionDetailNavigation?

    // MARK: - View controller lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Actions

    @IBAction func didSelectCancelButton() {
        navigation?.onCancel?()
    }

    @IBAction func didSelectSaveButton() {
        viewModel.amount = Decimal(arc4random() % 100)
        viewModel.save()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { _ in
                self.navigation?.onSave?()
            }, onError: { error in
                print(error)
            }).dispose()
    }

    // MARK: - Table view

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let detailSection = DetailSections(rawValue: section) else { fatalError() }
        return detailSection.numberOfRows
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let detailSection = DetailSections(rawValue: indexPath.section) else { fatalError() }
        let cell = tableView.dequeueReusableCell(withIdentifier: detailSection.cellIdentifier, for: indexPath)
        switch detailSection {
        case .category: cell.textLabel?.text = viewModel.category
        case .date: cell.textLabel?.text = String(describing: viewModel.date)
        case .amount: cell.textLabel?.text = String(describing: viewModel.amount)
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailSection = DetailSections(rawValue: indexPath.section) else { fatalError() }
        switch detailSection {
        case .category: navigation?.onEditCategory?(viewModel.category)
        default: break
        }
    }

}
