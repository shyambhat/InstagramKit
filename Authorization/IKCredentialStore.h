//
//  IKCredentialsManager.h
//  InstagramKit
//
//  Created by Shyam Bhat on 6/4/18.
//

#import <Foundation/Foundation.h>

@interface IKCredentialStore : NSObject

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
