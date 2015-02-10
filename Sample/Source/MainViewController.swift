class MainViewController: UIViewController {

	var config: LROAuthConfig!
	var settings: [String: String] = [:]

	override init() {
		let bundle = NSBundle(identifier: "com.liferay.mobile.sdk.Sample")
		let path = bundle.pathForResource("settings", ofType: "plist")
		settings = NSDictionary(contentsOfFile: path!) as [String: String]

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
		LRRequestToken.requestTokenWithConfig(
			config,
			server: self.settings["server"],
			onSuccess: {
				self.config = $0
				let URL = NSURL.URLWithString(self.config.authorizeTokenURL)
				UIApplication.sharedApplication().openURL(URL)
			},
			onFailure: {
				NSLog("%@", $0)
			}
		)
	}

	func accessTokenWithCallbackURL(callbackURL: NSURL) {
		LRAccessToken.accessTokenWithConfig(config)
	}

}