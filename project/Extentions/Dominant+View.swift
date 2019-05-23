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

extension UIView {
    
    func alignLeft(_ view: Any) {
        let leftConstraint = NSLayoutConstraint(item: view,
                                                attribute: .left,
                                                relatedBy: .equal,
                                                toItem: self,
                                                attribute: .left,
                                                multiplier: 1.0,
                                                constant: 0.0);
        self.addConstraint(leftConstraint);
    }
    
    func alignRight(_ view: Any) {
        let leftConstraint = NSLayoutConstraint(item: view,
                                                attribute: .right,
                                                relatedBy: .equal,
                                                toItem: self,
                                                attribute: .right,
                                                multiplier: 1.0,
                                                constant: 0.0);
        self.addConstraint(leftConstraint);
    }
}
