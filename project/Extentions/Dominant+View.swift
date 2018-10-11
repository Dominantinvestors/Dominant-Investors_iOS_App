import UIKit

extension UIView {
    
    internal class func instanceFromNib<T: UIView>() -> T {
        let nib = UINib(nibName: "\(T.self)", bundle: nil)
        guard let view = nib.instantiate(withOwner: nil, options: nil).first as? T  else {
            fatalError("\(T.self) not found")
        }
        return view
    }
}

extension UITableViewCell: ReuseIdentifier {
    
}
