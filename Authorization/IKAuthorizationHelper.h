//
//    Copyright (c) 2018 Shyam Bhat
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy of
//    this software and associated documentation files (the "Software"), to deal in
//    the Software without restriction, including without limitation the rights to
//    use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//    the Software, and to permit persons to whom the Software is furnished to do so,
//    subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//    FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//    COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//    IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//    CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <Foundation/Foundation.h>
#import "IKConstants.h"

NS_ASSUME_NONNULL_BEGIN

@interface IKAuthorizationHelper : NSObject

/**
 *  A convenience method to generate an authorization URL with Basic permissions
 *  to direct user to Instagram's login screen.
 *
 *  @return URL to direct user to Instagram's login screen.
 */
- (NSURL *)authorizationURL;


/**
 *  A convenience method to generate an authorization URL to direct user to Instagram's login screen.
 *
 *  @param scope Scope based on permissions required.
 *
 *  @return URL to direct user to Instagram's login screen.
 */
- (NSURL *)authorizationURLForScope:(InstagramKitLoginScope)scope;


/**
 *  A convenience method to extract and save the access code from an URL received in
 *  UIWebView's delegate method - webView: shouldStartLoadWithRequest: navigationType:
 *  @param url   URL from the request object.
 *  @param error Error in extracting token, if any.
 *
 *  @return YES if valid token extracted and saved, otherwise NO.
 */
- (BOOL)extractAndSaveAccessTokenFromURL:(NSURL *)url
                                   error:(NSError * _Nullable __autoreleasing *)error NS_SWIFT_NOTHROW;

@end

NS_ASSUME_NONNULL_END

