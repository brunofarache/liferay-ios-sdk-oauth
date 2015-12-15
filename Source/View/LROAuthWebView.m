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

#import "LROAuthWebView.h"

#import "LROAuth.h"
#import "LROAuthCallback.h"
#import "LRAccessToken.h"
#import "LRRequestToken.h"

#define DEFAUL_ELEMENT_ID_BUTTON_GRANT_ACCESS @"_3_WAR_oauthportlet_fm"
#define OAUTH_TOKEN @"oauthportlet_oauth_token"

/**
 * @author Allan Melo
 */
@interface LROAuthWebView() <UIWebViewDelegate>

@property (nonatomic, weak) id<LROAuthCallback> callback;
@property (nonatomic, strong) LROAuthConfig *config;

@end

@implementation LROAuthWebView

#pragma mark - Public Methods

- (void)start:(LROAuthConfig*)config callback:(id<LROAuthCallback>)callback{
	self.delegate = self;
	
	if (!self.elementIdButtonGrantAccess) {
		self.elementIdButtonGrantAccess = DEFAUL_ELEMENT_ID_BUTTON_GRANT_ACCESS;
	}
	
	self.config = config;
	self.callback = callback;
	
	[LRRequestToken requestTokenWithConfig:self.config
		onSuccess:^(LROAuthConfig *config){
			self.config = config;
			
			NSURL *url = [NSURL
				URLWithString:self.config.authorizeTokenURL];

			NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
			[self loadRequest:request];
		}
		onFailure:^(NSError *error){
			[self.callback onFailure:error];
		}
	 ];
}

#pragma mark - Private Methods

- (void) _clearAllCookies {
	NSHTTPCookieStorage *storage = [NSHTTPCookieStorage
		sharedHTTPCookieStorage];
	for (NSHTTPCookie *cookie in [storage cookies]) {
		[storage deleteCookie:cookie];
	}
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) _hideWebViewIfNecessary:(NSURLRequest *)request{
	if (self.allowAutomatically &&
		[request.URL.absoluteString rangeOfString:
		OAUTH_TOKEN].location != NSNotFound) {

		self.hidden = YES;
			
		if ([self.callback respondsToSelector:@selector(onGrantedAccess)]) {
			[self.callback onGrantedAccess];
		}
	}
}

- (void)_onCallBackURL:(NSURL *)url{
	self.config.verifier = url.absoluteString;
	
	[LRAccessToken accessTokenWithConfig:self.config
		onSuccess:^(LROAuthConfig *config) {
			config.server = self.config.server;
			
			self.config = config;
			[self.callback onSuccess:self.config];
			
		} onFailure:^(NSError *error) {
			[self.callback onFailure:error];
		}
	 ];	
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView{
	if (self.allowAutomatically) {
		
		NSString *queryButton =  [NSString
			stringWithFormat:@"document.getElementById('%@')",
			self.elementIdButtonGrantAccess];
		
		NSString *buttonHTML = [webView
			stringByEvaluatingJavaScriptFromString:
			[queryButton stringByAppendingString:@".innerHTML;"]];
		
		if (buttonHTML.length > 0) {
			[webView stringByEvaluatingJavaScriptFromString:
			[queryButton stringByAppendingString:@".submit();"]];
		}
	}
}

- (BOOL)webView:(UIWebView *)webView
		shouldStartLoadWithRequest:(NSURLRequest *)request
		navigationType:(UIWebViewNavigationType)navigationType{
	
	[self hideWebviewIfNecessary:request];
	
	if ([request.URL.absoluteString hasPrefix:self.config.callbackURL]) {
		
		[self _onCallBackURL:webView.request.URL];
		
		[self _clearAllCookies];
		
		return NO;
	}
	else if (self.callbackDenyUrl &&
			 [request.URL.absoluteString hasSuffix:self.callbackDenyUrl]){

		[self.callback onFailure:nil];
		
		[self _clearAllCookies];
		
		return NO;
	}
	
	return YES;
}

@end