import UIKit

internal class ViewModel<VC: UIViewController> {
    weak var viewController: VC?
    
    init(viewController: VC) {
        self.viewController = viewController
    }
}
