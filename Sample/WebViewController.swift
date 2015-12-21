class WebViewController: UIViewController, LROAuthCallback {

	@IBOutlet private weak var _activityIndicator: UIActivityIndicatorView!
	@IBOutlet private var _navigationItem: UINavigationItem!
	@IBOutlet private var _webview: LROAuthWebView!

	init(config: LROAuthConfig, onSuccess:(LROAuthConfig -> ())) {
		super.init(nibName : "WebViewController", bundle : nil)

		_config = config
		_onSuccess = onSuccess
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

	func onFailure(error: NSError) {
		close()
	}

	func onLoadPage(page: Page, webview webView: UIWebView, url: NSURL) {
		if (page == DENIED) {
			close()
		}
		else if (page == ASK_PERMISSION) {
			_webview.hidden = true
			_activityIndicator.startAnimating()
		}
	}

	func onSuccess(config: LROAuthConfig) {
		close()
		_onSuccess(config)
	}

	private var _config:LROAuthConfig!
	private var _onSuccess:(LROAuthConfig -> ())!

}