
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
  {
    setupAppearance()
    configureWithRootViewControllerType(ListController.self, embedInNavController: true)
    return true
  }

}

extension AppDelegate
{
  func configureWithRootViewControllerType <T: UIViewController> (_ type: T.Type, embedInNavController: Bool)
  {
    guard
      let className = NSStringFromClass(T.self).components(separatedBy: ".").last
      else { fatalError("cannot extract nib name from \(NSStringFromClass(T.self))") }
    
    window = UIWindow(frame: UIScreen.main.bounds)
    let rootViewController = T(nibName: className, bundle: nil)
    window?.rootViewController = embedInNavController ? UINavigationController(rootViewController: rootViewController) : rootViewController
    window?.makeKeyAndVisible()
  }
}

func setupAppearance()
{
  UINavigationBar.appearance().barStyle = .black
  UINavigationBar.appearance().isTranslucent = false
  UINavigationBar.appearance().tintColor = actionColor
  UINavigationBar.appearance().barTintColor = flixColor
  UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
  
  UIToolbar.appearance().barStyle = .black
  UIToolbar.appearance().isTranslucent = false
  UIToolbar.appearance().tintColor = actionColor
  UIToolbar.appearance().barTintColor = flixColor

  UILabel.appearance(whenContainedInInstancesOf: [MovieCell.self]).textColor = cellTextColor
}
