@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var rootViewController: MainViewController!
	var window: UIWindow!

	func application(
			application: UIApplication,
			didFinishLaunchingWithOptions options: [NSObject: AnyObject]?)
		-> Bool {

		window = UIWindow(frame: UIScreen.mainScreen().bounds)
		rootViewController = MainViewController()
		window.rootViewController = rootViewController
		window.makeKeyAndVisible()

		return true
	}

	func application(
			application: UIApplication, openURL callbackURL: NSURL,
			sourceApplication: String, annotation: AnyObject?)
		-> Bool {

		rootViewController.accessTokenWithCallbackURL(callbackURL)

		return true
	}

}