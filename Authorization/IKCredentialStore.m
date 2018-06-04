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
}

@end
