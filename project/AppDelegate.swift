import UIKit
import FBSDKCoreKit
import Inapps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        ApplicationDelegate.shared.application(application,
                                               didFinishLaunchingWithOptions: launchOptions)
        let productIds = ProductId.allCases.map { $0.rawValue }
        StoreKitManager.default.configure(productIds: productIds)
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        return ApplicationDelegate.shared.application(app, open: url, options: options)
    }
}

func setStatusBarBackgroundColor(_ color: UIColor) {
    guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
    statusBar.backgroundColor = color
}
