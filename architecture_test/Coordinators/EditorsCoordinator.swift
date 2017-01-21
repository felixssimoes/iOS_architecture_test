//
// Created by Félix Simões on 13/11/16.
//

import Foundation
import UIKit

struct TextValue {
    let label: String
    let value: String
}

class EditorsCoordinator {
    private struct StoryboardConstants {
        static let name = "Editors"
        static let textEditorIdentifier = "TextEditor"
        static let dateEditorIdentifier = "DateEditor"
        static let decimalEditorIdentifier = "DecimalEditor"
    }

    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func startTextEditor(value: TextValue, completion: @escaping (String) -> Void) {
        let vm = TextEditorViewModel(value: value.value, label: value.label)
        let vc = TextEditorViewController.new(viewModel: vm)
        vc.viewModel.cancelCallback = {
            self.navigationController.popViewController(animated: true)
        }
        vc.viewModel.saveCallback = {
            completion(vc.viewModel.value)
            self.navigationController.popViewController(animated: true)
        }
        navigationController.pushViewController(vc, animated: true)
    }
}
