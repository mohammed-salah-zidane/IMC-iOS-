//
//  AppDelegate.swift
//  IMC
//
//  Created by Mohamed Salah Zidane on 1/20/19.
//  Copyright © 2019 Mohamed Salah Zidane. All rights reserved.
//

import UIKit
let secondaryColor = UIColor(red: 20/255, green: 15/255, blue: 14/255, alpha: 1)
let  primaryColor  = UIColor(red: 14.0/255.0, green:175.0/255.0, blue: 127.0/255.0, alpha: 1.0)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        

        RunLoop.current.run(until: NSDate(timeIntervalSinceNow:0.5) as Date)
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.tintColor = primaryColor
        UINavigationBar.appearance().barTintColor = UIColor.white
        // UINavigationBar.appearance().tintColor = UIColor(red: 255.0/255.0, green:70.0/255.0, blue: 30.0/255.0, alpha: 1.0)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: primaryColor, NSAttributedString.Key.font: UIFont.init(name: "AvenirNext-DemiBold", size: 20.0)!]
        
        UITabBar.appearance().tintColor =  primaryColor
        UITabBar.appearance().barTintColor = .white


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


}

