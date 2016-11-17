//
// Created by Félix Simões on 13/11/16.
//

import Foundation

class TextEditorViewModel {
    var value: String
    var label: String

    var saveCallback: (() -> Void)?
    var cancelCallback: (() -> Void)?

    init(value: String, label: String) {
        self.value = value
        self.label = label
    }

    func save() {
        saveCallback?()
    }

    func cancel() {
        cancelCallback?()
    }
}
