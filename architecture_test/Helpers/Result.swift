//
//  Created by Félix Simões on 28/10/16.
//
//

import Foundation

enum Result<T, E: Error> {
    case success(T)
    case failure(E)
}
