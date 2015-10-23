
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{

  var window: UIWindow?

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
  {
    setupAppearance()
    configureWithRootViewControllerType(ListController.self, embedInNavController: true)
    return true
  }

}

extension AppDelegate
{
  func configureWithRootViewControllerType <T: UIViewController> (type: T.Type, embedInNavController: Bool)
  {
    guard
      let className = NSStringFromClass(T.self).componentsSeparatedByString(".").last
      else { fatalError("cannot extract nib name from \(NSStringFromClass(T.self))") }
    
    window = UIWindow(frame: UIScreen.mainScreen().bounds)
    let rootViewController = T(nibName: className, bundle: nil)
    window?.rootViewController = embedInNavController ? UINavigationController(rootViewController: rootViewController) : rootViewController
    window?.makeKeyAndVisible()
  }
}

func setupAppearance()
{
  UINavigationBar.appearance().barStyle = .Black
  UINavigationBar.appearance().translucent = false
  UINavigationBar.appearance().tintColor = actionColor
  UINavigationBar.appearance().barTintColor = flixColor
  UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
  
  UIToolbar.appearance().barStyle = .Black
  UIToolbar.appearance().translucent = false
  UIToolbar.appearance().tintColor = actionColor
  UIToolbar.appearance().barTintColor = flixColor

  UILabel.appearanceWhenContainedInInstancesOfClasses([MovieCell.self]).textColor = cellTextColor
}