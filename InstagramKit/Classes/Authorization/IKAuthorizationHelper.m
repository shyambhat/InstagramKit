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

#import "IKAuthorizationHelper.h"
#import "AFNetworking.h"
#import "IKConstants.h"
#import "IKCredentialsStore.h"

@interface IKAuthorizationHelper()

@property (nonatomic, copy, nonnull) NSString *appClientID;
@property (nonatomic, copy, nonnull) NSString *appRedirectURL;

@end

@implementation IKAuthorizationHelper

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

    }
    return self;
}

- (NSURL *)authorizationURL
{
    return [self authorizationURLForScope:IKLoginScopeBasic];
}


- (NSURL *)authorizationURLForScope:(IKLoginScope)scope
{
    NSDictionary *parameters = [self authorizationParametersWithScope:scope];
    NSURLRequest *authRequest = (NSURLRequest *)[[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:kIKAuthorizationURL parameters:parameters error:nil];
    return authRequest.URL;
}

- (NSDictionary *)authorizationParametersWithScope:(IKLoginScope)scope
{
    NSString *scopeString = [self stringForScope:scope];
    NSDictionary *parameters = @{ @"client_id": self.appClientID,
                                  @"redirect_uri": self.appRedirectURL,
                                  @"response_type": @"token",
                                  @"scope": scopeString };
    return parameters;
}


- (NSString *)stringForScope:(IKLoginScope)scope
{
    NSArray *typeStrings = @[@"basic", @"comments", @"relationships", @"likes", @"public_content", @"follower_list"];
    
    NSMutableArray *strings = [NSMutableArray arrayWithCapacity:typeStrings.count];
    [typeStrings enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSUInteger enumBitValueToCheck = 1 << idx;
        (scope & enumBitValueToCheck) ? [strings addObject:obj] : 0;
    }];
    
    return (strings.count) ? [strings componentsJoinedByString:@" "] : typeStrings[0];
}


- (BOOL)extractAndSaveAccessTokenFromURL:(NSURL *)url
                                  error:(NSError *__autoreleasing *)error
{
    return [self validAccessTokenFromURL:url
                         appRedirectPath:self.appRedirectURL
                                   error:error];
}

- (BOOL)validAccessTokenFromURL:(NSURL *)url
                appRedirectPath:(NSString *)appRedirectPath
                          error:(NSError *__autoreleasing *)error
{
    NSURL *appRedirectURL = [NSURL URLWithString:appRedirectPath];
    
    BOOL identicalURLSchemes = [appRedirectURL.scheme isEqual:url.scheme];
    BOOL identicalURLHosts = [appRedirectURL.host isEqual:url.host];
    // For app:// base URL, the host is nil.
    BOOL isAppURL = (BOOL)(appRedirectURL.host == nil);
    if (!identicalURLSchemes || (!isAppURL && !identicalURLHosts)) {
        return NO;
    }
    
    NSString *formattedURL = nil;
    // For app:// base url the fragment is nil
    if (url.fragment) {
        formattedURL = url.fragment;
    } else {
        formattedURL = url.resourceSpecifier;
    }
    
    NSString *token = [self queryStringParametersFromString:formattedURL][@"access_token"];
    BOOL success = token.length;
    if (success) {
        [[IKCredentialsStore sharedStore] saveAccessToken:token];
    }
    else if (error) {
        NSString *localizedDescription = NSLocalizedString(@"Authorization not granted.", @"Error notification to indicate Instagram OAuth token was not provided.");
        *error = [NSError errorWithDomain:InstagramKitErrorDomain
                                     code:InstagramKitAuthenticationFailedError
                                 userInfo:@{NSLocalizedDescriptionKey: localizedDescription}];
    }
    return success;
}


- (NSDictionary *)queryStringParametersFromString:(NSString*)string {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [[string componentsSeparatedByString:@"&"] enumerateObjectsUsingBlock:^(NSString * param, NSUInteger idx, BOOL *stop) {
        NSArray *pairs = [param componentsSeparatedByString:@"="];
        if ([pairs count] != 2) return;
        
        NSString *key = [pairs[0] stringByRemovingPercentEncoding];
        NSString *value = [pairs[1] stringByRemovingPercentEncoding];
        
        // Must manually clean when passed string is url.resourceSpecifier
        if ([[key substringToIndex:1] isEqualToString: @"#"]) {
            key = [key substringFromIndex:1];
        }
        
        [dict setObject:value forKey:key];
    }];
    return dict;
}


@end
