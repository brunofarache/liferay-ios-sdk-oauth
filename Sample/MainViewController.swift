class MainViewController: UIViewController {

	var config: LROAuthConfig!
	@IBOutlet var label: UILabel!
	var settings: [String: String] = [:]

	init() {
		let bundle = NSBundle(identifier: "com.liferay.mobile.sdk.Sample")
		let path = bundle?.pathForResource("settings", ofType: "plist")
		settings = NSDictionary(contentsOfFile: path!) as! [String: String]

		super.init(nibName: "MainViewController", bundle: nil)
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	@IBAction func loginWithBrowser(sender: UIButton) {
		self.label.text = ""
		createConfig()

		LRRequestToken.requestTokenWithConfig(
			config,
			onSuccess: {
				self.config = $0
				let URL = NSURL(string: self.config.authorizeTokenURL)
				UIApplication.sharedApplication().openURL(URL!)
			},
			onFailure: {
				NSLog("%@", $0)
			}
		)
	}

	@IBAction func loginWithWebView(sender: UIButton) {
		self.label.text = ""
		createConfig()

		let webViewController = WebViewController(
			config: self.config,
			onSuccess: { config in
				self.showSites(config)
			}
		)

		presentViewController(
			webViewController, animated: true, completion: nil)
	}
	
	func createConfig() {
		let server = settings["server"]
		let consumerKey = settings["oauth_consumer_key"]
		let consumerSecret = settings["oauth_consumer_secret"]
		let callbackURL = settings["oauth_callback_url"]
		
		self.config = LROAuthConfig(
			server: server, consumerKey: consumerKey,
			consumerSecret: consumerSecret, callbackURL: callbackURL)
	}
	
	func accessTokenWithCallbackURL(callbackURL: NSURL) {
		let params = LROAuth.extractRequestParams(callbackURL.query);
		config.verifier = params["oauth_verifier"] as! String

		LRAccessToken.accessTokenWithConfig(
			config,
			onSuccess: { config in
				self.showSites(config)
			},
			onFailure: {
				NSLog("%@", $0)
			}
		)
	}

	func showSites(config: LROAuthConfig!){
		let oauth = LROAuth(config: config)
		let session = LRSession(
			server: self.config.server, authentication: oauth)

		let service = LRGroupService_v62(session: session)

		do {
			let sites = try service.getUserSites()
			var text = ""

			for site in sites {
				text = text + (site["name"]! as! String) + "\n"
			}

			self.label.text = text
		}
		catch let error as NSError {
			NSLog("%@", error)
		}
	}

}