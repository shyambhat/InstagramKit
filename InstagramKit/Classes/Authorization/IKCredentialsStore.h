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

NS_ASSUME_NONNULL_BEGIN

@interface IKCredentialsStore : NSObject

/*
 * @abstract Gets the singleton instance.
 */
+ (instancetype)sharedStore;

/**
 *  Client Id of your App, as registered with Instagram.
 */
@property (nonatomic, readonly, nonnull) NSString *appClientID;


/**
 *  Redirect URL of your App, as registered with Instagram.
 */
@property (nonatomic, readonly, nonnull) NSString *appRedirectURL;

/**
 *  The oauth token stored in the account credential store, if available.
 *  If not empty, this implies user has granted access.
 */
@property (nonatomic, readonly, nullable) NSString *accessToken;


/**
 *  Save a new access token to the credential store.
 */
- (void)saveAccessToken:(NSString *)token;


/**
 *  Validate if authorization is done.
 *
 *  @return YES if access token present, otherwise NO.
 */
- (BOOL)isSessionValid;

/**
 *  Clears stored access token and browser cookies.
 */
- (void)clearAccessToken;


@end

NS_ASSUME_NONNULL_END
