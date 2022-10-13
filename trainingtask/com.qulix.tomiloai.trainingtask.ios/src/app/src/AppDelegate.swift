import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        let navVC = UINavigationController()
        let splash = SplashViewController()
        navVC.pushViewController(splash, animated: true)
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
        return true
    }
}
