//
//  AppDelegate.swift
//  Scribe
//
//  Created by Mikael Son on 5/2/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

import Firebase


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        self.setAppAttributes()
        return true
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

    private func setAppAttributes() {
        
//        let barFont = UIFont(name: "Montserrat-Bold", size: 19.0) ?? UIFont.boldSystemFont(ofSize: 19.0)
//        let barButtonFont = UIFont(name: "RobotoCondensed-Regular", size: 17) ?? UIFont.boldSystemFont(ofSize: 17.0)
//        let barButtonAttributes: [String: Any] = [
//            NSForegroundColorAttributeName: UIColor.scribeColorNavigationBlue
//            NSFontAttributeName: barButtonFont
//        ]
        
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
//        ha.barTintColor =
        
        
//        UINavigationBar.appearance().tintColor = UIColor.red
//        UINavigationBar.appearance().barTintColor = UIColor.red
//        ha.barTintColor
        
//        UINavigationBar.appearance().titleTextAttributes = barButtonAttributes
//        
//        let navBarFont = UIFont(name: "RobotoCondensed-Bold", size: 19) ?? UIFont.boldSystemFont(ofSize: 19.0)
//        let navBarAttributes: [String: Any] = [
//            NSForegroundColorAttributeName: UIColor.xoobaPrimary,
//            NSFontAttributeName: navBarFont
//        ]
//        UINavigationBar.appearance().titleTextAttributes = navBarAttributes
        
//        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
//        UINavigationBar.appearance().shadowImage = UIImage()
        
    }

}

