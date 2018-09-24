import UIKit

public extension UIStoryboard {
    enum Identifier: String {
        case Buy
        case AddSignal
        case SearchSignal
    }
    
    subscript<T: UIViewController>(_ identifier: Identifier) -> T {
        guard let controller = self.instantiateViewController(withIdentifier: identifier.rawValue) as? T else {
            fatalError()
        }
        return controller
    }
}
