//
//  AppDelegate.swift
//  FicFeed
//
//  Created by Michelle Ran on 7/24/16.
//  Copyright © 2016 Michelle Ran LLC. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Register for remote notifications
        if #available(iOS 8.0, *) {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        } else {
            // Fallback
            let types: UIRemoteNotificationType = [.Alert, .Badge, .Sound]
            application.registerForRemoteNotificationTypes(types)
        }
        
        FIRApp.configure()
        
        // Configuring nav bar appearance
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: UIFont(name: "Arial Rounded MT Bold", size: 18)!, NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        // Configuring tab bar appearance
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(red: 0xCC, green: 0x5A, blue: 0x5A)], forState: UIControlState.Normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState: UIControlState.Selected)
        
        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.Unknown)
        
        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
        var tokenString = ""
        for i in 0..<deviceToken.length {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        Cloud.setup(tokenString)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        if application.applicationState != UIApplicationState.Active {
            if let tab = window?.rootViewController as? UITabBarController {
                if let navigation = tab.selectedViewController as? UINavigationController {
                    if let link = userInfo["link"] as? String, title = userInfo["title"] as? String {
                        let ficController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Fic") as! FicController
                        ficController.ficTitle = title
                        ficController.link = NSURL(string: link)!
                        navigation.pushViewController(ficController, animated: true)
                    }
                }
            }
        }
    }
    
    // [START connect_to_fcm]
    func connectToFcm() {
        FIRMessaging.messaging().connectWithCompletion { (error) in }
    }
    // [END connect_to_fcm]
    
    func applicationDidBecomeActive(application: UIApplication) {
        connectToFcm()
    }
    
    // [START disconnect_from_fcm]
    func applicationDidEnterBackground(application: UIApplication) {
        FIRMessaging.messaging().disconnect()
    }
    // [END disconnect_from_fcm]
}

