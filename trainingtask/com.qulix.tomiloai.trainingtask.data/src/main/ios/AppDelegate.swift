//
//  AppDelegate.swift
//  trainingtask
//
//  Created by Артем Томило on 16.09.22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow()
        let navVC = UINavigationController()
        let splash = SplashViewController()
        navVC.pushViewController(splash, animated: true)
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
        return true
    }
}
