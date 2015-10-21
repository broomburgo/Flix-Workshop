
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{

  var window: UIWindow?

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
  {
    configureWithRootViewControllerType(ViewController)
    return true
  }

}

extension AppDelegate
{
  func configureWithRootViewControllerType <T: UIViewController> (type: T.Type)
  {
    window = UIWindow(frame: UIScreen.mainScreen().bounds)
    if let className = NSStringFromClass(T.self).componentsSeparatedByString(".").last
    {
      window?.rootViewController = T(nibName: className, bundle: nil)
    }
    else
    {
      fatalError("cannot extract nib name from \(NSStringFromClass(T.self))")
    }
    window?.makeKeyAndVisible()
  }
}
