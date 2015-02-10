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

#import "LRRequestToken.h"

#import "LROAuth.h"

/**
 * @author Bruno Farache
 */
@implementation LRRequestToken

+ (void)requestTokenWithSession:(LRSession *)session
		config:(LROAuthConfig *)config {

	[config setServer:session.server];

	LROAuth *oauth = [[LROAuth alloc] initWithConfig:config];

	NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
		initWithURL:[NSURL URLWithString:config.requestTokenURL]];

	[oauth authenticate:request];

	id<LRCallback> callback = session.callback;

	[[[NSURLSession sharedSession]
		dataTaskWithRequest:request
		completionHandler:^(NSData *data, NSURLResponse *response, NSError *e) {
			NSString *result = [[NSString alloc] initWithData:data
				encoding:NSUTF8StringEncoding];

			NSDictionary *params = [LROAuth extractRequestParams:result];

			[config setAuthorizeTokenURLWithServer:session.server
				params:params];

			[callback onSuccess:config];
		}
	] resume];
}

@end