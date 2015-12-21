class WebViewController: UIViewController, LROAuthCallback {

	@IBOutlet private weak var _activityIndicator: UIActivityIndicatorView!
	@IBOutlet private var _navigationItem: UINavigationItem!
	@IBOutlet private var _webview: LROAuthWebView!

	init(config: LROAuthConfig, resultBlock:((LROAuthConfig?) -> ())) {
		super.init(nibName : "WebViewController", bundle : nil)

		_config = config
		_resultBlock = resultBlock
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		_webview.start(_config, callback: self)

		let closeButton = UIBarButtonItem(
			barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self,
			action: "close")

		_navigationItem.setRightBarButtonItem(closeButton, animated: false)
		
	}

	func close() {
		_activityIndicator.stopAnimating()
		dismissViewControllerAnimated(true, completion: nil)
	}

	func onDenied() {
		close()
		_resultBlock(nil)
	}

	func onFailure(error: NSError!) {
		close()
		_resultBlock(nil)
	}

	func onPreGrant() {
		_webview.hidden = true
		_activityIndicator.startAnimating()
	}

	func onSuccess(config: LROAuthConfig!) {
		close()
		_resultBlock(config)
	}

	private var _config:LROAuthConfig!
	private var _resultBlock:((LROAuthConfig?) -> ())!

}