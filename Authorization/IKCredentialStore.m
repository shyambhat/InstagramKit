//
//  IKCredentialsManager.m
//  InstagramKit
//
//  Created by Shyam Bhat on 6/4/18.
//

#import "IKCredentialStore.h"
#import "IKConstants.h"
#if INSTAGRAMKIT_UICKEYCHAINSTORE
#import "UICKeyChainStore.h"
#endif


@interface IKCredentialStore()

@property (nonatomic, copy, nullable) NSString *accessToken;

#if INSTAGRAMKIT_UICKEYCHAINSTORE
@property (nonatomic, strong, nonnull) UICKeyChainStore *keychainStore;
#endif

@end


@implementation IKCredentialStore

- (instancetype)init
{
    self = [super init];
    if (self) {
        
#if INSTAGRAMKIT_UICKEYCHAINSTORE
        self.keychainStore = [UICKeyChainStore keyChainStoreWithService:InstagramKitKeychainStore];
        self.accessToken = self.keychainStore[kKeychainTokenKey];
#endif

    }
    return self;
}


- (void)saveAccessToken:(NSString *)accessToken
{
    self.accessToken = accessToken;
    
#if INSTAGRAMKIT_UICKEYCHAINSTORE
    self.keychainStore[kKeychainTokenKey] = self.accessToken;
#endif
    
    [[NSNotificationCenter defaultCenter] postNotificationName:InstagramKitUserAuthenticationChangedNotification object:nil];
}


- (BOOL)isSessionValid
{
    return self.accessToken != nil;
}


- (void)clearAccessToken
{
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [[storage cookies] enumerateObjectsUsingBlock:^(NSHTTPCookie *cookie, NSUInteger idx, BOOL *stop) {
        if ([cookie.domain rangeOfString:@"instagram.com"].location != NSNotFound) {
            [storage deleteCookie:cookie];
        }
    }];
    
    self.accessToken = nil;
}

@end
