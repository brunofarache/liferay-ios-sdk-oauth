class WebviewViewController: UIViewController, LROAuthCallback {
	
	@IBOutlet private var _navigationItem: UINavigationItem!
	@IBOutlet private var _webview: LROAuthWebView!
	@IBOutlet weak var _activityIndicator: UIActivityIndicatorView!
	
	init(config: LROAuthConfig, resultBlock:((LROAuthConfig?) -> Void)) {
		super.init(nibName : "WebviewViewController", bundle : nil)

		_config = config
		_resultBlock = resultBlock
	}
		
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		_webview.allowAutomatically = true;
		
		_webview.start(_config, callback: self)
		
		let backButtonBar = UIBarButtonItem(
			barButtonSystemItem: UIBarButtonSystemItem.Cancel,
			target: self, action: "close")
		
		_navigationItem.setRightBarButtonItem(backButtonBar, animated: false)
		
	}
	
	func close() {
		_activityIndicator.stopAnimating()
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	func onFailure(error: NSError!) {
		close()
		_resultBlock(nil)
	}
	
	func onGrantedAccess() {
		_activityIndicator.startAnimating()
	}
	
	func onSuccess(config: LROAuthConfig!) {
		close()
		_resultBlock(config)
	}

	private var _config:LROAuthConfig!
	private var _resultBlock:((LROAuthConfig?) -> Void)!

}