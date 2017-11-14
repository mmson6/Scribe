//
//  AppDelegate.swift
//  Scribe
//
//  Created by Mikael Son on 5/2/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

import Firebase
import Messages
import UserNotifications
import FirebaseInstanceID

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?

    var applicationStateString: String {
        if UIApplication.shared.applicationState == .active {
            return "active"
        } else if UIApplication.shared.applicationState == .background {
            return "background"
        }else {
            return "inactive"
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.setAppAttributes()
        self.addObservers()
        
        FirebaseApp.configure()
        application.registerForRemoteNotifications()
        self.requestNotificationAuthorization(application: application)
        if let userInfo = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] {
            NSLog("[RemoteNotification] applicationState: \(applicationStateString) didFinishLaunchingWithOptions for iOS9: \(userInfo)")
            //TODO: Handle background notification
        }
        
        return true
        
        
//        // In case if you need to know the permissions granted
//        UNUserNotificationCenter.current().getNotificationSettings(){ (setttings) in
//            switch setttings.soundSetting{
//            case .enabled:
//                print("enabled sound setting")
//            case .disabled:
//                print("setting has been disabled")
//            case .notSupported:
//                print("something vital went wrong here")
//            }
//        }
    }
    
    private func requestNotificationAuthorization(application: UIApplication) {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: Helper Functions
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleUserLogoutNotification), name: userLoggedOut, object: nil)
    }
    
    @objc private func handleUserLogoutNotification(notification: Notification) {
        NSLog("Handling User Logout Notification")
        
        let cmd = HandleSignOutCommand()
        cmd.onCompletion { result in
            switch result {
            case .success:
                NSLog("HandleSignOutCommand returned with success")
            case .failure:
                break
            }
        }
        cmd.execute()
    }
    
    private func setAppAttributes() {
        
        let navBarFont = UIFont(name: "Montserrat-Bold", size: 17.0) ?? UIFont.boldSystemFont(ofSize: 17.0)
        let navBarAttributes: [String: Any] = [
//            NSForegroundColorAttributeName: UIColor.scribeColorNavigationBlue,
            NSForegroundColorAttributeName: UIColor.scribeDesignTwoDarkBlue,
            NSFontAttributeName: navBarFont
        ]
        UINavigationBar.appearance().tintColor = UIColor.scribeDesignTwoDarkBlue
//        UINavigationBar.appearance().titleTextAttributes = navBarAttributes
        UINavigationBar.appearance().barTintColor = UIColor.white
        
//        let tabBarFont = UIFont(name: "Montserrat-Bold", size: 19.0) ?? UIFont.boldSystemFont(ofSize: 19.0)
//        let tabBarAttributes: [String: Any] = [
//            NSForegroundColorAttributeName: UIColor.scribeColorNavigationBlue,
//            NSFontAttributeName: navBarFont
//        ]
        
//        let ha = UITabBar.appearance()
        
//        UITabBar.appearance().titleTextAttributes = navBarAttributes
//
        UITabBar.appearance().tintColor = UIColor.scribeDesignTwoDarkBlue
        UITabBar.appearance().unselectedItemTintColor = .lightGray
        UITabBar.appearance().barTintColor = UIColor.white
        
    }
    
    // MARK: UNUserNotificationCenterDelegate Functions
    
    // iOS10+, called when presenting notification in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        NSLog("[UserNotificationCenter] applicationState: \(applicationStateString) willPresentNotification: \(userInfo)")
        //TODO: Handle foreground notification
        completionHandler([.alert])
    }
    
    // iOS10+, called when received response (default open, dismiss or custom action) for a notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        NotificationCenter.default.post(name: openFromSignUpRequest, object: nil)
        
        let userInfo = response.notification.request.content.userInfo
        NSLog("[UserNotificationCenter] applicationState: \(applicationStateString) didReceiveResponse: \(userInfo)")
        //TODO: Handle background notification
        completionHandler()
    }
    
    
    // MARK: MessagingDeledate Functions
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        NSLog("[RemoteNotification] didRefreshRegistrationToken: \(fcmToken)")
    }
    
    // iOS9, called when presenting notification in foreground
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        NSLog("[RemoteNotification] applicationState: \(applicationStateString) didReceiveRemoteNotification for iOS9: \(userInfo)")
        if UIApplication.shared.applicationState == .active {
            //TODO: Handle foreground notification
        } else {
            //TODO: Handle background notification
        }
    }
}

