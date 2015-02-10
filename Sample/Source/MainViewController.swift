class MainViewController: UIViewController {

	var config: LROAuthConfig!
	@IBOutlet var label: UILabel!
	var server: String?
	var settings: [String: String] = [:]

	override init() {
		let bundle = NSBundle(identifier: "com.liferay.mobile.sdk.Sample")
		let path = bundle.pathForResource("settings", ofType: "plist")
		settings = NSDictionary(contentsOfFile: path!) as [String: String]

		let consumerKey = settings["oauth_consumer_key"]
		let consumerSecret = settings["oauth_consumer_secret"]
		let callbackURL = settings["oauth_callback_url"]
		server = self.settings["server"]

		self.config = LROAuthConfig(
			consumerKey: consumerKey, consumerSecret: consumerSecret,
			callbackURL: callbackURL)

		super.init(nibName: "MainViewController", bundle: nil)
	}

	required init(coder: NSCoder) {
		super.init(coder: coder)
	}

	@IBAction func login(sender: UIButton) {
		self.label.text = ""

		LRRequestToken.requestTokenWithConfig(
			config,
			server: server,
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
		LRAccessToken.accessTokenWithConfig(
			config,
			onSuccess: {
				let oauth = LROAuth(config: $0)
				let session = LRSession(
					server: self.server, authentication: oauth)

				let service = LRGroupService_v62(session: session)
				var error: NSError?
				let sites = service.getUserSites(&error)
				var text = ""

				for site in sites {
					text = text + (site["name"]! as NSString) + "\n"
				}

				self.label.text = text
			},
			onFailure: {
				NSLog("%@", $0)
			}
		)
	}

}