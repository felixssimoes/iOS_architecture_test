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
    private let storyboard = UIStoryboard(name: StoryboardConstants.name, bundle: nil)

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func startTextEditor(value: TextValue, completion: @escaping (String) -> Void) {
        let vc = storyboard.instantiateViewController(withIdentifier: StoryboardConstants.textEditorIdentifier) as! TextEditorViewController
        vc.viewModel = TextEditorViewModel(value: value.value, label: value.label)
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
