import UIKit

public protocol Decorator {
    func decorate(_ navigationController: UINavigationController)
    func decorateBackButton(for viewController: UIViewController, selector: Selector)
}

open class NavigationController: UINavigationController {

    fileprivate let decorator: Decorator
    
    public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, decorator: Decorator){
        self.decorator = decorator
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        decorate()
    }
    
    public init?(coder aDecoder: NSCoder, decorator: Decorator) {
        self.decorator = decorator
        super.init(coder: aDecoder)
        decorate()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }
    
    fileprivate func decorate()  {
        decorator.decorate(self)
    }
    
    override open func pushViewController(_ viewController: UIViewController, animated: Bool) {
        view.endEditing(true) // better animation of hide keyboard

        super.pushViewController(viewController, animated: animated)
        decorator.decorateBackButton(for: viewController, selector: #selector(self.pop(sender:)))
    }
    
    @objc open func pop(sender: UIBarButtonItem) {
        view.endEditing(true) // better animation of hide keyboard
        
        if viewControllers.count > 1 {
            super.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}
