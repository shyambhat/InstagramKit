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

#import "IKCredentialsStore.h"
#import "IKConstants.h"
#if INSTAGRAMKIT_UICKEYCHAINSTORE
#import "UICKeyChainStore.h"
#endif


@interface IKCredentialsStore()

@property (nonatomic, copy, nonnull) NSString *appClientID;
@property (nonatomic, copy, nonnull) NSString *appRedirectURL;
@property (nonatomic, copy, nullable) NSString *accessToken;

#if INSTAGRAMKIT_UICKEYCHAINSTORE
@property (nonatomic, strong, nonnull) UICKeyChainStore *keychainStore;
#endif

@end

@implementation IKCredentialsStore


+ (instancetype)sharedStore {
    static IKCredentialsStore *_sharedStore = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sharedStore = [[IKCredentialsStore alloc] init];
    });
    return _sharedStore;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
        if (INSTAGRAMKIT_TEST_TARGET) {
            info = [[NSBundle bundleForClass:[self class]] infoDictionary];
        }
        
        self.appClientID = info[kInstagramAppClientIdConfigurationKey];
        self.appRedirectURL = info[kInstagramAppRedirectURLConfigurationKey];
        
        if (!self.appClientID || [self.appClientID isEqualToString:@""]) {
            NSLog(@"[InstagramKit] ERROR : Invalid Client ID. Please set a valid value for the key \"%@\" in the App's Info.plist file",kInstagramAppClientIdConfigurationKey);
        }
        
        if (!self.appRedirectURL || [self.appRedirectURL isEqualToString:@""]) {
            NSLog(@"[InstagramKit] ERROR : Invalid Redirect URL. Please set a valid value for the key \"%@\" in the App's Info.plist file",kInstagramAppRedirectURLConfigurationKey);
        }

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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:IKUserAuthenticationChangedNotification object:nil];
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

    [[NSNotificationCenter defaultCenter] postNotificationName:IKUserAuthenticationChangedNotification object:nil];

}


@end
