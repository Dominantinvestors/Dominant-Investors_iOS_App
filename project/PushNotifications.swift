import Foundation

enum PushNotificationsTypes: String {
    case none = "0"
    case NEW_IDEA = "1"
    case BUY_POINT = "2"
    case NEW_SIGNAL = "3"
    case NEW_FOLLOWER = "4"
    case NEW_MESSAGE = "5"
    case NEW_ADMIN_MESSAGE = "6"
    case STOP_LOSS = "7"
    case TARGET_PRICE = "8"
}

class PushNotifications {
    let window: UIWindow?
    
    let urlPath: Dynamic< [AnyHashable: Any]?> = Dynamic(nil)
    let fogotpassword: Dynamic<URL?> = Dynamic(nil)

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
        alertController.modalPresentationStyle = .fullScreen

        self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func openData(_ data: [AnyHashable: Any]) {
        if let data = data as? [String: Any],
            let type = data["type"] as? String
        {
            switch PushNotificationsTypes.init(rawValue: type) ?? .none {
            case .BUY_POINT:
                newSignal(data)
            default:
                print("PushNotificationsTypes not parced")
            }
        }
    }
    
    func newSignal(_ data: [String: Any]) {
        if let investor = data["user_id"] as? String,
            let signal = data["signal_id"] as? String
        {
            let navigation = MainNavigationController()
//            if PayViewController.isBought() {
                let controller: AlertNewSignalViewController = UIStoryboard.init(name: "Main", bundle: nil)[.AlertNewSignal]
                controller.investorID = Int(investor)
                controller.signalID = Int(signal)
                navigation.pushViewController(controller, animated: false)
//            } else {
//                let pay: PayViewController = UIStoryboard.init(name: "Main", bundle: nil)[.Pay]
//                pay.back = {
//                    navigation.dismiss(animated: true, completion: nil)
//                }
//                navigation.pushViewController(pay, animated: false )
//            }
  
            navigation.modalPresentationStyle = .fullScreen

            self.window?.rootViewController?.present(navigation, animated: true, completion: nil)
        }
    }
}
