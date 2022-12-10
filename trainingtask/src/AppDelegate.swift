import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        do {
            let settingsManager = try SettingsManager()
            let stub = Stub()
            let navVC = UINavigationController()
            let splash = SplashViewController(settingsManager: settingsManager, stub: stub)
            navVC.pushViewController(splash, animated: true)
            window?.rootViewController = navVC
            window?.makeKeyAndVisible()
        } catch {
            print(error)
        }
        return true
    }
}
