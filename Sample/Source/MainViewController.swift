class MainViewController: UIViewController {

	var config: LROAuthConfig!

	override init() {
		let consumerKey = "abb49e76-aafb-405a-8619-76be986e6752"
		let consumerSecret = "525041f5b3f8f248643c31dd384637ed"

		self.config = LROAuthConfig(
			consumerKey: consumerKey, consumerSecret: consumerSecret,
			callbackURL: "liferay://callback")

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