//
//    Copyright (c) 2013 Shyam Bhat
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

#import "InstagramEngine.h"
#import "InstagramUser.h"
#import "InstagramMedia.h"
#import "InstagramComment.h"

#define kKeyClientID @"client_id"
#define kKeyAccessToken @"access_token"

NSString *const kInstagramKitAppClientIdConfigurationKey = @"InstagramKitAppClientId";
NSString *const kInstagramKitAppRedirectUrlConfigurationKey = @"InstagramKitAppRedirectUrl";

NSString *const kInstagramKitBaseUrlConfigurationKey = @"InstagramKitBaseUrl";
NSString *const kInstagramKitAuthorizationUrlConfigurationKey = @"InstagramKitAuthorizationUrl";

NSString *const kInstagramKitBaseUrlDefault = @"https://api.instagram.com/v1/";
NSString *const kInstagramKitBaseUrl __deprecated = @"https://api.instagram.com/v1/";

NSString *const kInstagramKitAuthorizationUrlDefault = @"https://api.instagram.com/oauth/authorize/";
NSString *const kInstagramKitAuthorizationUrl __deprecated = @"https://api.instagram.com/oauth/authorize/";
NSString *const kInstagramKitErrorDomain = @"InstagramKitErrorDomain";

#define kData @"data"

@interface InstagramEngine()
{
    dispatch_queue_t mBackgroundQueue;
}

+ (NSDictionary*) sharedEngineConfiguration;

@property (nonatomic, copy) InstagramLoginBlock instagramLoginBlock;
@property (nonatomic, strong) AFHTTPRequestOperationManager *operationManager;

@end

@implementation InstagramEngine

#pragma mark - Initializers -

+ (InstagramEngine *)sharedEngine {
    static InstagramEngine *_sharedEngine = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sharedEngine = [[InstagramEngine alloc] init];
    });
    return _sharedEngine;
}

+ (NSDictionary*) sharedEngineConfiguration {
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"InstagramKit" withExtension:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfURL:url];
    dict = dict ? dict : [[NSBundle mainBundle] infoDictionary];
    return dict;
}

- (id)init {
    
    NSDictionary *sharedEngineConfiguration = [InstagramEngine sharedEngineConfiguration];

    id url = nil;

    url = sharedEngineConfiguration[kInstagramKitBaseUrlConfigurationKey];

    if (url) {
        url = [NSURL URLWithString:url];
    } else {
        url = [NSURL URLWithString:kInstagramKitBaseUrlDefault];
    }

    if (self = [super init]) {

        NSAssert(url, @"Base URL not valid: %@", sharedEngineConfiguration[kInstagramKitBaseUrlConfigurationKey]);
        self.operationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];

        self.appClientID =  sharedEngineConfiguration[kInstagramKitAppClientIdConfigurationKey];
        self.appRedirectURL = sharedEngineConfiguration[kInstagramKitAppRedirectUrlConfigurationKey];

        url = sharedEngineConfiguration[kInstagramKitAuthorizationUrlConfigurationKey];
        self.authorizationURL = url ? url : kInstagramKitAuthorizationUrlDefault;

        mBackgroundQueue = dispatch_queue_create("background", NULL);

        self.operationManager.requestSerializer = [[AFJSONRequestSerializer alloc] init];
        self.operationManager.responseSerializer = [[AFJSONResponseSerializer alloc] init];

        NSAssert(self.appClientID, @"App Client ID invalid: %@", self.appClientID);
        NSAssert([NSURL URLWithString:self.appRedirectURL], @"App Redirect URL invalid: %@", self.appRedirectURL);
        NSAssert([NSURL URLWithString:self.authorizationURL], @"Authorization URL invalid: %@", self.authorizationURL);

    }

    return self;

}


#pragma mark - Login - 

- (void) cancelLogin
{

    if (self.instagramLoginBlock)
    {

        NSString *localizedDescription = NSLocalizedString(@"User canceled Instagram Login.", @"Error notification for Instagram Login cancelation.");

        NSError *error = [NSError errorWithDomain:kInstagramKitErrorDomain code:kInstagramKitErrorCodeUserCancelled userInfo:@{
            NSLocalizedDescriptionKey: localizedDescription
        }];

        self.instagramLoginBlock(error);

    }

}

- (void) loginWithBlock:(InstagramLoginBlock)block
{

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@&response_type=token",
        self.authorizationURL,
        self.appClientID,
        self.appRedirectURL]];

    self.instagramLoginBlock = block;

    [[UIApplication sharedApplication] openURL:url];

}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{

    NSURL *appRedirectURL = [NSURL URLWithString:self.appRedirectURL];

    if (![appRedirectURL.scheme isEqual:url.scheme] || ![appRedirectURL.host isEqual:url.host])
    {
        return NO;
    }

    NSString* accessToken = [self queryStringParametersFromString:url.fragment][@"access_token"];
    
    if (accessToken)
    {
        self.accessToken = accessToken;
        if (self.instagramLoginBlock) self.instagramLoginBlock(nil);
    }
    else if (self.instagramLoginBlock)
    {

        NSString *localizedDescription = NSLocalizedString(@"Authorization not granted.", @"Error notification to indicate Instagram OAuth token was not provided.");

        NSError *error = [NSError errorWithDomain:kInstagramKitErrorDomain code:kInstagramKitErrorCodeAccessNotGranted userInfo:@{
            NSLocalizedDescriptionKey: localizedDescription
        }];

        self.instagramLoginBlock(error);

    }

    self.instagramLoginBlock = nil;
    return YES;

}

-(NSDictionary*) queryStringParametersFromString:(NSString*)string {

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    for (NSString * param in [string componentsSeparatedByString:@"&"]) {
        
        NSArray *pairs = [param componentsSeparatedByString:@"="];
        if ([pairs count] != 2) continue;
        
        NSString *key = [pairs[0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *value = [pairs[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        [dict setObject:value forKey:key];
        
    }
    
    return dict;
    
}

#pragma mark - Base Call -

- (void)getPath:(NSString*)path
     responseModel:(Class)modelClass
     parameters:(NSDictionary *)parameters
        success:(void (^)(id response))success
        failure:(void (^)(NSError* error, NSInteger statusCode))failure
{

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:parameters];

    if (self.accessToken) {
        [params setObject:self.accessToken forKey:kKeyAccessToken];
    }


    [params setObject:self.appClientID forKey:kKeyClientID];
    [self.operationManager GET:path
        parameters:params
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               NSDictionary *responseDictionary = (NSDictionary *)responseObject;
               BOOL collection = ([responseDictionary[kData] isKindOfClass:[NSArray class]]);
               if (collection) {
                   NSArray *responseObjects = responseDictionary[kData];
                   NSMutableArray*objects = [NSMutableArray arrayWithCapacity:responseObjects.count];
                   dispatch_async(mBackgroundQueue, ^{
                       for (NSDictionary *info in responseObjects) {
                           id model = [[modelClass alloc] initWithInfo:info];
                           [objects addObject:model];
                       }
                       dispatch_async(dispatch_get_main_queue(), ^{
                           success(objects);
                       });
                   });
               }
               else {
                   id model = [[modelClass alloc] initWithInfo:responseDictionary[kData]];
                   success(model);
               }
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               failure(error,[[operation response] statusCode]);
           }];
}


#pragma mark - Media -

- (void)getPopularMediaWithSuccess:(void (^)(NSArray *media))success
                           failure:(void (^)(NSError* error))failure
{
    [self getPath:@"media/popular" responseModel:[InstagramMedia class] parameters:nil success:^(id response) {
        NSArray *objects = response;
        success(objects);
    } failure:^(NSError *error, NSInteger statusCode) {
        failure(error);
    }];
}

- (void)getMedia:(NSString *)mediaId
               withSuccess:(void (^)(InstagramMedia *media))success
                   failure:(void (^)(NSError* error))failure
{
    [self getPath:[NSString stringWithFormat:@"media/%@",mediaId] responseModel:[InstagramMedia class] parameters:nil success:^(id response) {
        InstagramMedia *media = response;
        success(media);
    } failure:^(NSError *error, NSInteger statusCode) {
        failure(error);
    }];
}

#pragma mark - Users -

- (void)getSelfUserDetailWithSuccess:(void (^)(InstagramUser *userDetail))success
                             failure:(void (^)(NSError* error))failure
{
    [self getPath:@"users/self" responseModel:[InstagramUser class] parameters:nil success:^(id response) {
        InstagramUser *userDetail = response;
        success(userDetail);
    } failure:^(NSError *error, NSInteger statusCode) {
        failure(error);
    }];
}

- (void)getUserDetails:(InstagramUser *)user
     withSuccess:(void (^)(InstagramUser *userDetail))success
         failure:(void (^)(NSError* error))failure
{
    [self getPath:[NSString stringWithFormat:@"users/%@",user.Id] responseModel:[InstagramUser class] parameters:nil success:^(id response) {
        InstagramUser *userDetail = response;
        success(userDetail);
    } failure:^(NSError *error, NSInteger statusCode) {
        failure(error);
    }];
}

- (void)getMediaForUser:(NSString *)userId count:(NSInteger)count
        withSuccess:(void (^)(NSArray *feed))success
            failure:(void (^)(NSError* error))failure
{
    [self getPath:[NSString stringWithFormat:@"users/%@/media/recent",userId] responseModel:[InstagramMedia class] parameters:@{kCount:[NSString stringWithFormat:@"%d",count]} success:^(id response) {
        NSArray *objects = response;
        success(objects);
        
    } failure:^(NSError *error, NSInteger statusCode) {
        failure(error);
    }];

}

#pragma mark - Tags -

- (void)getMediaWithTag:(NSString *)tag
        withSuccess:(void (^)(NSArray *feed))success
            failure:(void (^)(NSError* error))failure
{
    [self getPath:[NSString stringWithFormat:@"tags/%@/media/recent",tag] responseModel:[InstagramMedia class] parameters:nil success:^(id response) {
        NSArray *objects = response;
        success(objects);
    } failure:^(NSError *error, NSInteger statusCode) {
        failure(error);
    }];
}

#pragma mark - Self -

- (void)getSelfFeed:(NSInteger)count
        withSuccess:(void (^)(NSArray *feed))success
                failure:(void (^)(NSError* error))failure
{
    [self getPath:[NSString stringWithFormat:@"users/self/feed"] responseModel:[InstagramMedia class] parameters:nil success:^(id response) {
        NSArray *objects = response;
        success(objects);
        
    } failure:^(NSError *error, NSInteger statusCode) {
        failure(error);
    }];
    
}

- (void)getSelfLikesWithSuccess:(void (^)(NSArray *feed))success
                        failure:(void (^)(NSError* error))failure
{
    [self getPath:[NSString stringWithFormat:@"users/self/media/liked"] responseModel:[InstagramMedia class] parameters:nil success:^(id response) {
        NSArray *objects = response;
        success(objects);
        
    } failure:^(NSError *error, NSInteger statusCode) {
        failure(error);
    }];
    
}

#pragma mark - Comments -

- (void)getCommentsOnMedia:(NSString *)mediaId
               withSuccess:(void (^)(NSArray *comments))success
                   failure:(void (^)(NSError* error))failure
{
    [self getPath:[NSString stringWithFormat:@"media/%@/comments",mediaId] responseModel:[InstagramComment class] parameters:nil success:^(id response) {
        NSArray *objects = response;
        success(objects);
        
    } failure:^(NSError *error, NSInteger statusCode) {
        failure(error);
    }];
    
}

@end
