@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(
			application: UIApplication,
			didFinishLaunchingWithOptions options: [NSObject: AnyObject]?)
		-> Bool {

		window = UIWindow(frame: UIScreen.mainScreen().bounds)
		window!.rootViewController = MainViewController()
		window!.makeKeyAndVisible()

		return true
	}

	func application(
			application: UIApplication, openURL URL: NSURL,
			sourceApplication: String, annotation: AnyObject?)
		-> Bool {

		let query = URL.query

		NSLog("%@", query!)

		return true
	}

}