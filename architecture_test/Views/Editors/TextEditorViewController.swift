//
// Created by Félix Simões on 13/11/16.
//

import Foundation
import UIKit

class TextEditorViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var fieldNameLabel: UILabel!

    private (set) var viewModel: TextEditorViewModel!
    
    static func new(viewModel: TextEditorViewModel) -> TextEditorViewController {
        let sb = UIStoryboard(name: "Editors", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "TextEditor") as! TextEditorViewController
        vc.viewModel = viewModel
        return vc
    }

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
