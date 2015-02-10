class MainViewController: UIViewController {

	var config: LROAuthConfig!

	override init() {
		let bundle = NSBundle(identifier: "com.liferay.mobile.sdk.Sample")
		let path = bundle.pathForResource("settings", ofType: "plist")
		let settings = NSDictionary(contentsOfFile: path!) as [String: String]

		let consumerKey = settings["oauth_consumer_key"]
		let consumerSecret = settings["oauth_consumer_secret"]
		let callbackURL = settings["oauth_callback_url"]

		self.config = LROAuthConfig(
			consumerKey: consumerKey, consumerSecret: consumerSecret,
			callbackURL: callbackURL)

		super.init(nibName:"MainViewController", bundle:nil)
	}

	required init(coder: NSCoder) {
		super.init(coder: coder)
	}

	@IBAction func login(sender: UIButton) {
		let session = LRSession(server: "http://localhost:8080")

		session.onSuccess({ (result: AnyObject!) -> () in
			self.config = result as LROAuthConfig
			let URL = NSURL.URLWithString(self.config.authorizeTokenURL)

			UIApplication.sharedApplication().openURL(URL)
		},
		onFailure: { (e: NSError!) -> () in
			NSLog("%@", e)
		})

		LRRequestToken.requestTokenWithSession(session, config: config)
	}

	func accessTokenWithCallbackURL(callbackURL: NSURL) {
		LRAccessToken.accessTokenWithConfig(config)
	}

}