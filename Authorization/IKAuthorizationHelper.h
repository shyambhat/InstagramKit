//
//  IKAuthorizationHelper.h
//  InstagramKit
//
//  Created by Shyam Bhat on 6/4/18.
//

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

