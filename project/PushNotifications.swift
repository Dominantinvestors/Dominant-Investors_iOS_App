import Foundation

class PushNotifications {
    let window: UIWindow?
    
    let urlPath: Dynamic< [AnyHashable: Any]?> = Dynamic(nil)
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func showNotification(_ title: String?, _ subtitle: String, _ data: [AnyHashable: Any]) {
        let alertController = UIAlertController(title: title,
                                                message: subtitle,
                                                preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { action in
            self.urlPath.value = data
        })
        alertController.addAction(defaultAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in })
        alertController.addAction(cancelAction)
        
        self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func openData(_ data: [AnyHashable: Any]) {
 
        let navigation = MainNavigationController()
        let controller: AlertNewSignalViewController = UIStoryboard.init(name: "Main", bundle: nil)[.AlertNewSignal]
        controller.investorID = "1"
        controller.signalID = "4"
        navigation.pushViewController(controller, animated: false)
        self.window?.rootViewController?.present(navigation, animated: true, completion: nil)

        if let data = data as? [String: Any], let type = data["type"] as? String {
            ////Type 3
            if type == "new_investor_signal",
                let investor = data["investor_id"] as? String,
                let signal = data["signal_id"] as? String
            {
                let navigation = MainNavigationController()
                let controller: AlertNewSignalViewController = UIStoryboard.init(name: "Main", bundle: nil)[.AlertNewSignal]
                controller.investorID = investor
                controller.signalID = signal
                navigation.pushViewController(controller, animated: false)
                self.window?.rootViewController?.present(navigation, animated: true, completion: nil)
            }
            
        }
    }
}
