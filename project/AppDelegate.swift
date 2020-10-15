import UIKit
import FacebookCore
import FBSDKCoreKit
import Firebase
import UserNotifications
import Inapps
import AppsFlyerLib

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AppsFlyerTrackerDelegate {

    var window: UIWindow?

    var notification: PushNotifications!

    @objc func sendLaunch(app:Any) {
          AppsFlyerTracker.shared().trackAppLaunch()
      }
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        FirebaseApp.configure()
    
        let pushNotifications = PushNotifications(window: window)
        self.notification = pushNotifications
        ServiceLocator.shared.registerService(service: pushNotifications)
        
        registerForRemoteNotifications()

        let productIds = ProductId.allCases.map { $0.rawValue }
        StoreKitManager.default.configure(productIds: productIds)
        
        AppsFlyerTracker.shared().appsFlyerDevKey = "9vgpkncYVtFfKQy7f5kJ7A"
        AppsFlyerTracker.shared().appleAppID = "1147502198"
        AppsFlyerTracker.shared().delegate = self
        AppsFlyerTracker.shared().isDebug = false
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(sendLaunch),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        AppEvents.activateApp()
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.host == "fogotpassword" {
            self.notification.fogotpassword.value = url
            return true
        }
        AppsFlyerTracker.shared().handleOpen(url, options: options)

        return ApplicationDelegate.shared.application(app, open: url, options: options)
    }
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
      AppsFlyerTracker.shared().handleOpen(url, sourceApplication: sourceApplication, withAnnotation: annotation)
      return true
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
           AppsFlyerTracker.shared().handlePushNotification(userInfo)
       }
  
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
           AppsFlyerTracker.shared().continue(userActivity, restorationHandler: nil)
           return true
       }
    
    func application(_ application: UIApplication,
                      didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        registerDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
    }
    
    private func registerForRemoteNotifications() {
        UIApplication.shared.registerForRemoteNotifications()
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
    }
    
   private func registerDeviceToken(_ deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
      func onConversionDataSuccess(_ data: [AnyHashable: Any]) {
          print("\(data)")
          if let status = data["af_status"] as? String{
              if(status == "Non-organic"){
                  if let sourceID = data["media_source"] , let campaign = data["campaign"]{
                      print("This is a Non-Organic install. Media source: \(sourceID)  Campaign: \(campaign)")
                  }
              } else {
                  print("This is an organic install.")
              }
              if let is_first_launch = data["is_first_launch"] , let launch_code = is_first_launch as? Int {
                  if(launch_code == 1){
                      print("First Launch")
                  } else {
                      print("Not First Launch")
                  }
              }
          }
      }
      func onConversionDataFail(_ error: Error) {
         print("\(error)")
      }
      
     func onAppOpenAttribution(_ attributionData: [AnyHashable: Any]) {
          print("onAppOpenAttribution data:")
          for (key, value) in attributionData {
              print(key, ":",value)
          }
      }
      func onAppOpenAttributionFailure(_ error: Error) {
          print("\(error)")
      }
}

//func setStatusBarBackgroundColor(_ color: UIColor) {
//    guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
//    statusBar.backgroundColor = color
//}

extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        let content = notification.request.content
        Messaging.messaging().appDidReceiveMessage(content.userInfo)
        self.notification.showNotification(content.title, content.body, content.userInfo)
        
        completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void)
    {
        let data = response.notification.request.content.userInfo
        self.notification.urlPath.value = data
        completionHandler()
    }
}
