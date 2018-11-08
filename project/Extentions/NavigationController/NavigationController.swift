import UIKit

public struct ColorPalette {
    static let NavigationTin = UIColor(red: 0 / 255, green: 0 / 255, blue: 0 / 255, alpha: 0.75)
    static let NavigationDisplaedTin = UIColor.gray
}

fileprivate struct Empty: Decorator {
    func decorate(_ navigationController: UINavigationController) {
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.isOpaque = false
        navigationController.navigationBar.isTranslucent = true
        navigationController.navigationBar.backgroundColor = .white
        navigationController.navigationBar.tintColor = ColorPalette.NavigationTin
        navigationController.navigationBar.titleTextAttributes = [.foregroundColor: ColorPalette.NavigationTin, .font: Fonts.regular(20)]
    }
    
    func decorateBackButton(for viewController: UIViewController, selector: Selector) {
        let backButton = UIBarButtonItem(image: UIImage(named: "back"),
                                         style: .plain,
                                         target: viewController.navigationController,
                                         action: selector)
        
        viewController.navigationItem.leftBarButtonItem = backButton
        viewController.navigationItem.hidesBackButton = true
    }
}

fileprivate struct Dark: Decorator {
    func decorate(_ navigationController: UINavigationController) {
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.isOpaque = false
        navigationController.navigationBar.isTranslucent = true
        navigationController.navigationBar.backgroundColor = .clear
        navigationController.navigationBar.tintColor = .white
        navigationController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white, .font: Fonts.regular(20)]
    }
    
    func decorateBackButton(for viewController: UIViewController, selector: Selector) {
        let backButton = UIBarButtonItem(image: UIImage(named: "backArrow"),
                                         style: .plain,
                                         target: viewController.navigationController,
                                         action: selector)
        
        viewController.navigationItem.leftBarButtonItem = backButton
        viewController.navigationItem.hidesBackButton = true
    }
}

class DarkNavigationController: NavigationController {
    
    init(nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil, decorator: Dark())
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, decorator: Dark())
    }
}

class MainNavigationController: NavigationController {
    
    init(nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil, decorator: Empty())
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, decorator: Empty())
    }
}

class LoginNavigationController: NavigationController {
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil, decorator: Empty())
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, decorator: Empty())
    }
}

