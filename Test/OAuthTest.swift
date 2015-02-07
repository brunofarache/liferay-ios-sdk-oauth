/**
* Copyright (c) 2000-present Liferay, Inc. All rights reserved.
*
* This library is free software; you can redistribute it and/or modify it under
* the terms of the GNU Lesser General Public License as published by the Free
* Software Foundation; either version 2.1 of the License, or (at your option)
* any later version.
*
* This library is distributed in the hope that it will be useful, but WITHOUT
* ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
* FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
* details.
*/

import XCTest

/**
* @author Bruno Farache
*/
class Test: XCTestCase {

	var server: String?
	var settings: [String: String] = [:]

    override func setUp() {
		super.setUp()

		let bundle = NSBundle(identifier: "com.liferay.mobile.sdk.Test")
		let path = bundle.pathForResource("settings", ofType: "plist")

		self.settings = NSDictionary(contentsOfFile: path!) as [String: String]
		self.server = self.settings["server"]!
	}

	func testGetUserSites() {
		let consumerKey = self.settings["oauth_consumer_key"]
		let consumerSecret = self.settings["oauth_consumer_secret"]
		let token = self.settings["oauth_token"]
		let tokenSecret = self.settings["oauth_token_secret"]

		if (LRValidator.isEmpty(consumerKey) ||
			LRValidator.isEmpty(consumerSecret) ||
			LRValidator.isEmpty(token) ||
			LRValidator.isEmpty(tokenSecret)) {

			return
		}

		let config = LROAuthConfig(
			consumerKey: consumerKey, consumerSecret: consumerSecret,
			token: token, tokenSecret: tokenSecret)

		let oauth = LROAuth(config: config)
		let session = LRSession(
			server: self.server, authentication: oauth)

		let service = LRGroupService_v62(session: session)
		var error: NSError?
		let sites = service.getUserSites(&error)

		XCTAssertNil(error)
		XCTAssertTrue(sites.count > 0)

		XCTAssert("/test" == sites[0]["friendlyURL"] as NSString)
		XCTAssert("/guest" == sites[1]["friendlyURL"] as NSString)
    }

	func testHeader() {
		let config = LROAuthConfig(
			consumerKey: "dpf43f3p2l4k3l03", consumerSecret: "kd94hf93k423kf44",
			token: "nnch734d00sl2jdk", tokenSecret: "pfkkdhi9sl3r4s00")

		config.nonce = "kllo9940pd9333jh"
		config.timestamp = "1191242096"

		let oauth = LROAuth(config: config)
		let URL = NSURL(
			string: "http://photos.example.net/photos?file=vacation.jpg" +
				"&size=original")

		let request = NSMutableURLRequest(URL: URL)
		oauth.authenticate(request)
		let header = request.valueForHTTPHeaderField("Authorization")

		XCTAssert(
			header == "OAuth oauth_consumer_key=\"dpf43f3p2l4k3l03\", " +
				"oauth_nonce=\"kllo9940pd9333jh\", " +
				"oauth_signature_method=\"HMAC-SHA1\", " +
				"oauth_timestamp=\"1191242096\", " +
				"oauth_token=\"nnch734d00sl2jdk\", " +
				"oauth_version=\"1.0\", " +
				"oauth_signature=\"tR3%2BTy81lMeYAr%2FFid0kMTYa%2FWM%3D\"")
	}

	func testRequestToken() {
		let monitor = TRVSMonitor()
		var URL = ""
		var error: NSError?

		let consumerKey = self.settings["oauth_consumer_key"]
		let consumerSecret = self.settings["oauth_consumer_secret"]

		if (LRValidator.isEmpty(consumerKey) ||
			LRValidator.isEmpty(consumerSecret)) {

			return
		}

		let session = LRSession(server: self.server)

		let success = { (result: AnyObject!) -> () in
			URL = result as String
			monitor.signal()
		}

		let failure = { (e: NSError?) -> () in
			error = e
			monitor.signal()
		}

		session.onSuccess(success, onFailure: failure)

		let config = LROAuthConfig(
			consumerKey: "dpf43f3p2l4k3l03", consumerSecret: "kd94hf93k423kf44",
			callbackURL: "http://callback")

		LRRequestToken.requestTokenWithSession(session, config: config)
		monitor.wait()

		let authorizationURL = "\(self.server!)/c/portal/oauth/" +
			"authorize?oauth_token="

		NSLog("URL %@", URL)
		NSLog("authorizationURL %@", authorizationURL)

		XCTAssertNil(error)
		XCTAssert(URL.hasPrefix(authorizationURL))
	}

	func testSignature() {
		let config = LROAuthConfig(
			consumerKey: "dpf43f3p2l4k3l03", consumerSecret: "kd94hf93k423kf44",
			token: "nnch734d00sl2jdk", tokenSecret: "pfkkdhi9sl3r4s00")

		let oauth = LROAuth(config: config)
		let method = "GET"
		let URL = "http://photos.example.net/photos"
		var params = config.params

		params["oauth_timestamp"] = "1191242096"
		params["oauth_nonce"] = "kllo9940pd9333jh"
		params["file"] = "vacation.jpg"
		params["size"] = "original"

		let signatureBase = oauth._getSignatureBaseWithMethod(
		method, URL: URL, params: params)

		XCTAssert(
			signatureBase == "GET&http%3A%2F%2Fphotos.example.net%2Fphotos&" +
				"file%3Dvacation.jpg" +
				"%26oauth_consumer_key%3Ddpf43f3p2l4k3l03" +
				"%26oauth_nonce%3Dkllo9940pd9333jh" +
				"%26oauth_signature_method%3DHMAC-SHA1" +
				"%26oauth_timestamp%3D1191242096" +
				"%26oauth_token%3Dnnch734d00sl2jdk" +
				"%26oauth_version%3D1.0" +
				"%26size%3Doriginal")
	}

}