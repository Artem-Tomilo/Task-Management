import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        do {
            let settingsManager = try SettingsManager()
            let server = Stub()
            let navigationViewController = UINavigationController()
            let splashViewController = SplashViewController(settingsManager: settingsManager, server: server)
            navigationViewController.pushViewController(splashViewController, animated: true)
            window?.rootViewController = navigationViewController
            window?.makeKeyAndVisible()
        } catch {
            fatalError(error.localizedDescription)
        }
        return true
    }
}
