//
// Created by Félix Simões on 13/11/16.
//

import Foundation
import UIKit

class TextEditorViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var fieldNameLabel: UILabel!

    var viewModel: TextEditorViewModel!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fieldNameLabel.text = viewModel.label
        textField.text = viewModel.value
    }

    @IBAction func didSelectSaveButton() {
        guard let value = textField.text, !value.isEmpty else { return }
        viewModel.value = value
        viewModel.save()
    }

    @IBAction func didSelectCancelButton() {
        viewModel.cancel()
    }
}
