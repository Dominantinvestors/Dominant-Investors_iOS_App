//
//  AppDelegate.swift
//  Dominant Investors
//
//  Created by Nekit on 18.02.17.
//  Copyright © 2017 Dominant. All rights reserved.
//

import UIKit
import Quickblox
import Fabric
import FBSDKCoreKit
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Fabric.with([Crashlytics.self])
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
//        FBSDKAppLinkUtility.fetchDeferredAppLink { (url, error) in
//            
//        }
        
//        QBSettings.setLogLevel(.errors)
//        QBSettings.setApplicationID(67714)
//        QBSettings.setAuthKey("OpuJ8LmRmBfmCqU")
//        QBSettings.setAuthSecret("EHWwdvuUjNVHCgv")
//        QBSettings.setAccountKey("E8fxy9j9qwWXczPKb4yp")
//
//        DMQuickBloxService.sharedInstance.regUser()
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
         return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }
    
    
}

