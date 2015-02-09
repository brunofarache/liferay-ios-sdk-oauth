class MainViewController: UIViewController {

	override init() {
		super.init(nibName:"MainViewController", bundle:nil)
	}

	required init(coder: NSCoder) {
		super.init(coder: coder)
	}

	@IBAction func login(sender: UIButton) {
		let session = LRSession(server: "http://localhost:8080")

		session.onSuccess({ (result: AnyObject!) -> () in
			let URL = NSURL.URLWithString(result as String)
			UIApplication.sharedApplication().openURL(URL)
		},
		onFailure: { (e: NSError!) -> () in
			NSLog("%@", e)
		})

		let consumerKey = "abb49e76-aafb-405a-8619-76be986e6752"
		let consumerSecret = "525041f5b3f8f248643c31dd384637ed"

		let config = LROAuthConfig(
			consumerKey: consumerKey, consumerSecret: consumerSecret,
			callbackURL: "http://callback")

		LRRequestToken.requestTokenWithSession(session, config: config)
	}

}