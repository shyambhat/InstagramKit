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
#import "AFNetworking.h"
#import "InstagramUser.h"
#import "InstagramMedia.h"
#import "InstagramComment.h"
#import "InstagramTag.h"
#import "InstagramPaginationInfo.h"
#import "InstagramLocation.h"


NSString *const kInstagramKitBaseUrlConfigurationKey = @"InstagramKitBaseUrl";
NSString *const kInstagramKitAuthorizationUrlConfigurationKey = @"InstagramKitAuthorizationUrl";
NSString *const kInstagramKitBaseUrl = @"https://api.instagram.com/v1/";
NSString *const kInstagramKitAuthorizationUrl = @"https://api.instagram.com/oauth/authorize/";

NSString *const kInstagramAppClientIdConfigurationKey = @"InstagramAppClientId";
NSString *const kInstagramAppRedirectURLConfigurationKey = @"InstagramAppRedirectURL";

NSString *const kInstagramKitErrorDomain = @"InstagramKitErrorDomain";
NSString *const kKeyClientID = @"client_id";
NSString *const kKeyAccessToken = @"access_token";

NSString *const kRelationshipActionKey = @"action";
NSString *const kRelationshipActionFollow = @"follow";
NSString *const kRelationshipActionUnfollow = @"unfollow";
NSString *const kRelationshipActionBlock = @"block";
NSString *const kRelationshipActionUnblock = @"unblock";
NSString *const kRelationshipActionApprove = @"approve";
NSString *const kRelationshipActionDeny = @"deny";

NSString *const kPagination = @"pagination";


typedef enum
{
    kPaginationMaxId,
    kPaginationMaxLikeId,
    kPaginationMaxTagId,
    kPaginationCursor
} MaxIdKeyType;


@interface InstagramEngine()
{
    dispatch_queue_t mBackgroundQueue;
}

@property (nonatomic, copy) InstagramLoginBlock instagramLoginBlock;
@property (nonatomic, strong) AFHTTPSessionManager *httpManager;

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


- (NSDictionary*)clientConfiguration {

    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSMutableDictionary *configuration = [NSMutableDictionary dictionary];
    if (info[kInstagramAppClientIdConfigurationKey]) {
        configuration[kInstagramAppClientIdConfigurationKey] = info[kInstagramAppClientIdConfigurationKey];
    }
    if (info[kInstagramAppRedirectURLConfigurationKey]) {
        configuration[kInstagramAppRedirectURLConfigurationKey] = info[kInstagramAppRedirectURLConfigurationKey];
    }
    configuration[kInstagramKitBaseUrlConfigurationKey] = kInstagramKitBaseUrl;
    configuration[kInstagramKitAuthorizationUrlConfigurationKey] = kInstagramKitAuthorizationUrl;
    
    return [NSDictionary dictionaryWithDictionary:configuration];
}


- (instancetype)init {
    if (self = [super init])
    {
        NSURL *baseURL = [NSURL URLWithString:kInstagramKitBaseUrl];
        self.httpManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
        self.httpManager.responseSerializer = [[AFJSONResponseSerializer alloc] init];

        NSDictionary *configuration = [self clientConfiguration];
        self.appClientID = configuration[kInstagramAppClientIdConfigurationKey];
        self.appRedirectURL = configuration[kInstagramAppRedirectURLConfigurationKey];
        self.authorizationURL = kInstagramKitAuthorizationUrl;

        mBackgroundQueue = dispatch_queue_create("background", NULL);

        NSAssert(IKNotNull(self.appClientID) && ![self.appClientID isEqualToString:@""] && ![self.appClientID isEqualToString:@"<Client Id here>"], @"Invalid Instagram Client ID. Please set a valid value for the key \"InstagramAppClientId\" in Info.plist");
        
        NSAssert(IKNotNull(self.appRedirectURL) && ![self.appRedirectURL isEqualToString:@""] && ![self.appRedirectURL isEqualToString:@"<Redirect URL here>"], @"Invalid Redirect URL. Please set a valid value for the key \"InstagramAppRedirectURL\" in Info.plist", self.appRedirectURL);
        
        NSAssert([NSURL URLWithString:self.authorizationURL], @"Authorization URL invalid: %@", self.authorizationURL);
    }
    return self;
}


#pragma mark - Login -


- (NSURL *)authorizarionURLForScope:(IKLoginScope)scope
{
    NSDictionary *parameters = [self authorizationParametersWithScope:scope];
    NSURLRequest *authRequest = (NSURLRequest *)[[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:self.authorizationURL parameters:parameters error:nil];
    return authRequest.URL;
}


- (void)redirectToLoginForScope:(IKLoginScope)scope completionBlock:(InstagramLoginBlock)block
{
    NSURL *authURL = [self authorizarionURLForScope:scope];
    self.instagramLoginBlock = block;
    [[UIApplication sharedApplication] openURL:authURL];
}


- (NSDictionary *)authorizationParametersWithScope:(IKLoginScope)scope
{
    NSDictionary *configuration = [self clientConfiguration];
    NSString *scopeString = [self stringForScope:scope];
    NSDictionary *parameters = @{
                                 @"client_id": configuration[kInstagramAppClientIdConfigurationKey],
                                 @"redirect_uri": configuration[kInstagramAppRedirectURLConfigurationKey],
                                 @"response_type": @"token",
                                 @"scope": scopeString
                                 };
    return parameters;
}


#define kBitsUsedByIKLoginScope 4


- (NSString *)stringForScope:(IKLoginScope)scope
{
    
    NSArray *typeStrings = @[@"basic",@"comments",@"relationships",@"likes"];
    NSMutableArray *strings = [NSMutableArray arrayWithCapacity:4];
    
    for (NSUInteger i=0; i < kBitsUsedByIKLoginScope; i++)
    {
        NSUInteger enumBitValueToCheck = 1 << i;
        if (scope & enumBitValueToCheck)
            [strings addObject:[typeStrings objectAtIndex:i]];
    }
    if (!strings.count) {
        return @"basic";
    }
    
    return [strings componentsJoinedByString:@"+"];
}


- (void)cancelLogin
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


- (void)logout
{
//    Clear all cookies so the next time the user wishes to switch accounts,
//    they can do so
    
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.accessToken = nil;
    
    NSLog(@"User is now logged out");
    
#ifdef DEBUG
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Logged out" message:@"The user is now logged out. Proceed with dismissing the view. This message only appears in the debug environment." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
    
    [alert show];
    
#endif
    
}


- (BOOL)isSessionValid
{
    return self.accessToken != nil;
}


-(NSDictionary*)queryStringParametersFromString:(NSString*)string {

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (NSString * param in [string componentsSeparatedByString:@"&"])
    {
        NSArray *pairs = [param componentsSeparatedByString:@"="];
        if ([pairs count] != 2) continue;
        NSString *key = [pairs[0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *value = [pairs[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [dict setObject:value forKey:key];
    }
    return dict;
}


#pragma mark - Base Calls -


- (void)getPath:(NSString *)path
     parameters:(NSDictionary *)parameters
  responseModel:(Class)modelClass
        success:(void (^)(id response, InstagramPaginationInfo *paginationInfo))success
        failure:(void (^)(NSError* error, NSInteger statusCode))failure
{

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:parameters];

    if (self.accessToken) {
        [params setObject:self.accessToken forKey:kKeyAccessToken];
    }
    else
    {
        [params setObject:self.appClientID forKey:kKeyClientID];
    }
    
    NSString *percentageEscapedPath = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    [self.httpManager GET:percentageEscapedPath
        parameters:params
           success:^(NSURLSessionDataTask *task, id responseObject) {
               NSDictionary *responseDictionary = (NSDictionary *)responseObject;
               NSDictionary *pInfo = responseDictionary[kPagination];
               InstagramPaginationInfo *paginationInfo = (pInfo)?[[InstagramPaginationInfo alloc] initWithInfo:pInfo andObjectType:modelClass]: nil;
               BOOL multiple = ([responseDictionary[kData] isKindOfClass:[NSArray class]]);
               if (multiple) {
                   NSArray *responseObjects = responseDictionary[kData];
                   NSMutableArray*objects = [NSMutableArray arrayWithCapacity:responseObjects.count];
                   dispatch_async(mBackgroundQueue, ^{
                       if (modelClass) {
                           for (NSDictionary *info in responseObjects) {
                               id model = [[modelClass alloc] initWithInfo:info];
                               [objects addObject:model];
                           }
                       }
                       dispatch_async(dispatch_get_main_queue(), ^{
                           success(objects, paginationInfo);
                       });
                   });
               }
               else {
                   id model = nil;
                   if (modelClass && IKNotNull(responseDictionary[kData]))
                   {
                       if (modelClass == [NSDictionary class]) {
                           model = [[NSDictionary alloc] initWithDictionary:responseDictionary[kData]];
                       }
                       else
                       {
                           model = [[modelClass alloc] initWithInfo:responseDictionary[kData]];
                       }
                   }
                   success(model, paginationInfo);
               }
           }
           failure:^(NSURLSessionDataTask *task, NSError *error) {
               failure(error, ((NSHTTPURLResponse *)[task response]).statusCode);
           }];
}


- (void)postPath:(NSString *)path
     parameters:(NSDictionary *)parameters
   responseModel:(Class)modelClass
        success:(void (^)(NSDictionary *responseObject))success
        failure:(void (^)(NSError* error, NSInteger statusCode))failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:parameters];
    if (self.accessToken) {
        [params setObject:self.accessToken forKey:kKeyAccessToken];
    }
    else
        [params setObject:self.appClientID forKey:kKeyClientID];
    
    [self.httpManager POST:path
                    parameters:params
                       success:^(NSURLSessionDataTask *task, id responseObject) {
                           NSDictionary *responseDictionary = (NSDictionary *)responseObject;
                           success(responseDictionary);
                       }
                       failure:^(NSURLSessionDataTask *task, NSError *error) {
                           failure(error,((NSHTTPURLResponse*)[task response]).statusCode);
                       }];
}


- (void)deletePath:(NSString *)path
      parameters:(NSDictionary *)parameters
   responseModel:(Class)modelClass
         success:(void (^)(void))success
         failure:(void (^)(NSError* error, NSInteger statusCode))failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:parameters];
    if (self.accessToken) {
        [params setObject:self.accessToken forKey:kKeyAccessToken];
    }
    else
        [params setObject:self.appClientID forKey:kKeyClientID];
    [self.httpManager DELETE:path
                  parameters:params
                     success:^(NSURLSessionDataTask *task, id responseObject) {
                         if (success) {
                             success();
                         }
                     }
                     failure:^(NSURLSessionDataTask *task, NSError *error) {
                         if (failure) {
                             failure(error,((NSHTTPURLResponse*)[task response]).statusCode);
                         }
                     }];
}


- (NSDictionary *)parametersFromCount:(NSInteger)count maxId:(NSString *)maxId andMaxIdType:(MaxIdKeyType)keyType
{
    NSMutableDictionary *params = nil;
    if (count) {
        params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)count], kCount, nil];
        if (maxId) {
            NSString *key = nil;
            switch (keyType) {
                case kPaginationMaxId:
                    key = kMaxId;
                    break;
                case kPaginationMaxLikeId:
                    key = kMaxLikeId;
                    break;
                case kPaginationMaxTagId:
                    key = kMaxTagId;
                    break;
                case kPaginationCursor:
                    key = kCursor;
                    break;
            }
            [params setObject:maxId forKey:key];
        }
    }
    return params?[NSDictionary dictionaryWithDictionary:params]:nil;
}


#pragma mark - Media -


- (void)getMedia:(NSString *)mediaId
     withSuccess:(InstagramMediaDetailBlock)success
         failure:(InstagramFailureBlock)failure
{
    [self getPath:[NSString stringWithFormat:@"media/%@",mediaId] parameters:nil responseModel:[InstagramMedia class] success:^(id response, InstagramPaginationInfo *paginationInfo) {
        if(success)
		{
			InstagramMedia *media = response;
			success(media);
		}
    } failure:^(NSError *error, NSInteger statusCode) {
        if(failure)
		{
			failure(error, statusCode);
		}
    }];
}


- (void)getPopularMediaWithSuccess:(InstagramMediaBlock)success
                           failure:(InstagramFailureBlock)failure
{
    [self getPath:@"media/popular" parameters:nil responseModel:[InstagramMedia class] success:^(id response, InstagramPaginationInfo *paginationInfo) {
        NSArray *objects = response;
        if(success)
		{
			success(objects, paginationInfo);
		}
    } failure:^(NSError *error, NSInteger statusCode) {
        if(failure)
		{
			failure(error, statusCode);
		}
    }];
}


- (void)getMediaAtLocation:(CLLocationCoordinate2D)location
               withSuccess:(InstagramMediaBlock)success
                   failure:(InstagramFailureBlock)failure
{
    [self getMediaAtLocation:location count:0 maxId:nil withSuccess:success failure:failure];
}


- (void)getMediaAtLocation:(CLLocationCoordinate2D)location
                     count:(NSInteger)count
                     maxId:(NSString *)maxId
               withSuccess:(InstagramMediaBlock)success
                   failure:(InstagramFailureBlock)failure
{
    NSDictionary *params = [self parametersFromCount:count maxId:maxId andMaxIdType:kPaginationMaxId];
    [self getPath:[NSString stringWithFormat:@"media/search?lat=%f&lng=%f",location.latitude,location.longitude] parameters:params responseModel:[InstagramMedia class] success:^(id response, InstagramPaginationInfo *paginationInfo) {
        if(success)
		{
			NSArray *objects = response;
			success(objects, paginationInfo);
		}
    } failure:^(NSError *error, NSInteger statusCode) {
        if(failure)
		{
			failure(error, statusCode);
		}
    }];
}
                         
- (void)searchLocationsAtLocation:(CLLocationCoordinate2D)loction
                       withSuccess:(InstagramLocationsBlock)success
                           failure:(InstagramFailureBlock)failure
{
     [self getPath:[NSString stringWithFormat:@"locations/search?lat=%f&lng=%f", loction.latitude, loction.longitude] parameters:nil responseModel:[InstagramLocation class] success:^(id response, InstagramPaginationInfo *paginationInfo) {
         if (success) {
             NSArray *objects = response;
             success(objects);
         }
     } failure:^(NSError *error, NSInteger statusCode) {
         if (failure) {
             failure(error, statusCode);
         }
     }];
}


- (void)searchLocationsAtLocation:(CLLocationCoordinate2D)loction
                     distanceInMeters:(NSInteger)distance
                     withSuccess:(InstagramLocationsBlock)success
                     failure:(InstagramFailureBlock)failure
{
     [self getPath:[NSString stringWithFormat:@"locations/search?lat=%f&lng=%f&distance=%ld", loction.latitude, loction.longitude, (long)distance] parameters:nil responseModel:[InstagramLocation class] success:^(id response, InstagramPaginationInfo *paginationInfo) {
         if (success) {
             NSArray *objects = response;
             success(objects);
         }
     } failure:^(NSError *error, NSInteger statusCode) {
         if (failure) {
             failure(error, statusCode);
         }
     }];
}
                         

- (void)getLocationWithId:(NSString*)locationId
                     withSuccess:(InstagramLocationBlock)success
                     failure:(InstagramFailureBlock)failure
 {
     [self getPath:[NSString stringWithFormat:@"locations/%@", locationId] parameters:nil responseModel:[InstagramLocation class] success:^(id response, InstagramPaginationInfo *paginationInfo) {
         if (success) {
             success(response);
         }
     } failure:^(NSError *error, NSInteger statusCode) {
         if (failure) {
             failure(error, statusCode);
         }
     }];
 }
                         

- (void)getMediaAtLocationWithId:(NSString*)locationId
                     withSuccess:(InstagramMediaBlock)success
                     failure:(InstagramFailureBlock)failure
 {
     [self getPath:[NSString stringWithFormat:@"locations/%@/media/recent", locationId] parameters:nil responseModel:[InstagramMedia class] success:^(id response, InstagramPaginationInfo *paginationInfo) {
         if (success) {
             success(response, paginationInfo);
         }
     } failure:^(NSError *error, NSInteger statusCode) {
         if (failure) {
             failure(error, statusCode);
         }
     }];
 }


#pragma mark - Users -


- (void)getUserDetails:(InstagramUser *)user
           withSuccess:(InstagramUserBlock)success
               failure:(InstagramFailureBlock)failure
{
    [self getPath:[NSString stringWithFormat:@"users/%@",user.Id]  parameters:nil responseModel:[NSDictionary class] success:^(id response, InstagramPaginationInfo *paginationInfo) {
        if(success && IKNotNull(response))
		{
            [user updateDetails:response];
			success(user);
		}
    } failure:^(NSError *error, NSInteger statusCode) {
        if(failure)
		{
			failure(error, statusCode);
		}
    }];
}


- (void)getMediaForUser:(NSString *)userId
            withSuccess:(InstagramMediaBlock)success
                failure:(InstagramFailureBlock)failure
{
    [self getMediaForUser:userId count:0 maxId:nil withSuccess:success failure:failure];
}


- (void)getMediaForUser:(NSString *)userId
                  count:(NSInteger)count
                  maxId:(NSString *)maxId
            withSuccess:(InstagramMediaBlock)success
                failure:(InstagramFailureBlock)failure
{
    NSDictionary *params = [self parametersFromCount:count maxId:maxId andMaxIdType:kPaginationMaxId];
    [self getPath:[NSString stringWithFormat:@"users/%@/media/recent",userId] parameters:params responseModel:[InstagramMedia class] success:^(id response, InstagramPaginationInfo *paginationInfo) {
        if(success)
		{
			NSArray *media = response;
			success(media, paginationInfo);
		}
    } failure:^(NSError *error, NSInteger statusCode) {
        if(failure)
		{
			failure(error, statusCode);
		}
    }];
}


- (void)searchUsersWithString:(NSString *)string
                  withSuccess:(InstagramUsersBlock)success
                      failure:(InstagramFailureBlock)failure
{
    [self getPath:[NSString stringWithFormat:@"users/search?q=%@",string] parameters:nil responseModel:[InstagramUser class] success:^(id response, InstagramPaginationInfo *paginationInfo) {
        if(success)
		{
			NSArray *objects = response;
			success(objects, paginationInfo);
		}
    } failure:^(NSError *error, NSInteger statusCode) {
        if(failure)
		{
			failure(error, statusCode);
		}
    }];
}


#pragma mark - Self -


- (void)getSelfUserDetailsWithSuccess:(InstagramUserBlock)success
                              failure:(InstagramFailureBlock)failure
{
    [self getPath:@"users/self" parameters:nil responseModel:[InstagramUser class] success:^(id response, InstagramPaginationInfo *paginationInfo) {
        InstagramUser *userDetail = response;
		if(success)
		{
			success(userDetail);
		}
    } failure:^(NSError *error, NSInteger statusCode) {
        if(failure)
		{
			failure(error, statusCode);
		}
    }];
}


- (void)getSelfFeedWithSuccess:(InstagramMediaBlock)success
                       failure:(InstagramFailureBlock)failure
{
    [self getSelfFeedWithCount:0 maxId:nil success:success failure:failure];
}


- (void)getSelfFeedWithCount:(NSInteger)count
                       maxId:(NSString *)maxId
                     success:(InstagramMediaBlock)success
                     failure:(InstagramFailureBlock)failure
{
    NSDictionary *params = [self parametersFromCount:count maxId:maxId andMaxIdType:kPaginationMaxId];
    [self getPath:[NSString stringWithFormat:@"users/self/feed"] parameters:params responseModel:[InstagramMedia class] success:^(id response, InstagramPaginationInfo *paginationInfo) {
        if(success)
		{
			NSArray *objects = response;
			success(objects, paginationInfo);
		}
    } failure:^(NSError *error, NSInteger statusCode) {
        if(failure)
		{
			failure(error, statusCode);
		}
    }];
}


- (void)getMediaLikedBySelfWithSuccess:(InstagramMediaBlock)success
                               failure:(InstagramFailureBlock)failure
{
    [self getMediaLikedBySelfWithCount:0 maxId:nil success:success failure:failure];
}


- (void)getMediaLikedBySelfWithCount:(NSInteger)count
                               maxId:(NSString *)maxId
                             success:(InstagramMediaBlock)success
                             failure:(InstagramFailureBlock)failure
{
    NSDictionary *params = [self parametersFromCount:count maxId:maxId andMaxIdType:kPaginationMaxLikeId];
    [self getPath:[NSString stringWithFormat:@"users/self/media/liked"] parameters:params responseModel:[InstagramMedia class] success:^(id response, InstagramPaginationInfo *paginationInfo) {
        if(success)
		{
			NSArray *objects = response;
			success(objects, paginationInfo);
		}
    } failure:^(NSError *error, NSInteger statusCode) {
        if(failure)
		{
			failure(error, statusCode);
		}
    }];
}

- (void)getSelfRecentMediaWithSuccess:(InstagramMediaBlock)success
							  failure:(InstagramFailureBlock)failure
{
    [self getSelfRecentMediaWithCount:0 maxId:nil success:success failure:failure];
}


- (void)getSelfRecentMediaWithCount:(NSInteger)count
                              maxId:(NSString *)maxId
                            success:(InstagramMediaBlock)success
                            failure:(InstagramFailureBlock)failure
{
    NSDictionary *params = [self parametersFromCount:count maxId:maxId andMaxIdType:kPaginationMaxId];
	[self getPath:[NSString stringWithFormat:@"users/self/media/recent"] parameters:params responseModel:[InstagramMedia class] success:^(id response, InstagramPaginationInfo *paginationInfo) {
		if(success)
		{
			NSArray *objects = response;
			success(objects, paginationInfo);
		}
	} failure:^(NSError *error, NSInteger statusCode) {
		if(failure)
		{
			failure(error, statusCode);
		}
	}];
}

#pragma mark - Tags -


- (void)getTagDetailsWithName:(NSString *)name
                  withSuccess:(InstagramTagBlock)success
                      failure:(InstagramFailureBlock)failure
{
    [self getPath:[NSString stringWithFormat:@"tags/%@",name] parameters:nil responseModel:[InstagramTag class] success:^(id response, InstagramPaginationInfo *paginationInfo) {
        if(success)
		{
			InstagramTag *tag = response;
			success(tag);
		}
    } failure:^(NSError *error, NSInteger statusCode) {
        if(failure)
		{
			failure(error, statusCode);
		}
    }];
}


- (void)getMediaWithTagName:(NSString *)tag
                withSuccess:(InstagramMediaBlock)success
                    failure:(InstagramFailureBlock)failure
{
    [self getMediaWithTagName:tag count:0 maxId:nil withSuccess:success failure:failure];
}


- (void)getMediaWithTagName:(NSString *)tag
                      count:(NSInteger)count
                      maxId:(NSString *)maxId
                withSuccess:(InstagramMediaBlock)success
                    failure:(InstagramFailureBlock)failure
{
    NSDictionary *params = [self parametersFromCount:count maxId:maxId andMaxIdType:kPaginationMaxTagId];
    [self getPath:[NSString stringWithFormat:@"tags/%@/media/recent",tag] parameters:params responseModel:[InstagramMedia class] success:^(id response, InstagramPaginationInfo *paginationInfo) {
		if(success)
		{
			NSArray *objects = response;
			success(objects, paginationInfo);
		}
    } failure:^(NSError *error, NSInteger statusCode) {
        if(failure)
		{
			failure(error, statusCode);
		}
    }];
}


- (void)searchTagsWithName:(NSString *)name
               withSuccess:(InstagramTagsBlock)success
                   failure:(InstagramFailureBlock)failure
{
    [self searchTagsWithName:name count:0 maxId:nil withSuccess:success failure:failure];
}


- (void)searchTagsWithName:(NSString *)name
                     count:(NSInteger)count
                     maxId:(NSString *)maxId
               withSuccess:(InstagramTagsBlock)success
                   failure:(InstagramFailureBlock)failure
{
    NSDictionary *params = [self parametersFromCount:count maxId:maxId andMaxIdType:kPaginationMaxId];
    [self getPath:[NSString stringWithFormat:@"tags/search?q=%@",name] parameters:params responseModel:[InstagramTag class] success:^(id response, InstagramPaginationInfo *paginationInfo) {
        if(success)
		{
			NSArray *objects = response;
			success(objects, paginationInfo);
		}
    } failure:^(NSError *error, NSInteger statusCode) {
        if(failure)
		{
			failure(error, statusCode);
		}
    }];
}


#pragma mark - Comments -


- (void)getCommentsOnMedia:(NSString *)mediaId
               withSuccess:(InstagramCommentsBlock)success
                   failure:(InstagramFailureBlock)failure
{
    [self getPath:[NSString stringWithFormat:@"media/%@/comments",mediaId] parameters:nil responseModel:[InstagramComment class] success:^(id response, InstagramPaginationInfo *paginationInfo) {
        if(success)
		{
			NSArray *objects = response;
			success(objects);
		}
    } failure:^(NSError *error, NSInteger statusCode) {
        if(failure)
		{
			failure(error, statusCode);
		}
    }];
}


- (void)createComment:(NSString *)commentText
              onMedia:(NSString *)mediaId
          withSuccess:(dispatch_block_t)success
              failure:(InstagramFailureBlock)failure
{
    NSDictionary *params = [NSDictionary dictionaryWithObjects:@[commentText] forKeys:@[kText]];
    [self postPath:[NSString stringWithFormat:@"media/%@/comments",mediaId] parameters:params responseModel:nil success:^(NSDictionary *responseObject)
    {
        if(success)
		{
			success();
		}
    } failure:^(NSError *error, NSInteger statusCode) {
        if(failure)
		{
			failure(error, statusCode);
		}
    }];
}


- (void)removeComment:(NSString *)commentId
              onMedia:(NSString *)mediaId
          withSuccess:(dispatch_block_t)success
              failure:(InstagramFailureBlock)failure
{
    [self deletePath:[NSString stringWithFormat:@"media/%@/comments/%@",mediaId,commentId] parameters:nil responseModel:nil success:^{
        if(success)
		{
			success();
		}
    } failure:^(NSError *error, NSInteger statusCode) {
        if(failure)
		{
			failure(error, statusCode);
		}
    }];
}


#pragma mark - Likes -


- (void)getLikesOnMedia:(NSString *)mediaId
            withSuccess:(InstagramObjectsBlock)success
                failure:(InstagramFailureBlock)failure
{
    [self getPath:[NSString stringWithFormat:@"media/%@/likes",mediaId] parameters:nil responseModel:[InstagramUser class] success:^(id response, InstagramPaginationInfo *paginationInfo) {
        if(success)
		{
			NSArray *objects = response;
			success(objects, paginationInfo);
		}
    } failure:^(NSError *error, NSInteger statusCode) {
        if(failure)
		{
			failure(error, statusCode);
		}
    }];
}


- (void)likeMedia:(NSString *)mediaId
      withSuccess:(dispatch_block_t)success
          failure:(InstagramFailureBlock)failure
{
    [self postPath:[NSString stringWithFormat:@"media/%@/likes",mediaId] parameters:nil responseModel:nil success:^(NSDictionary *responseObject)
     {
         if(success)
         {
             success();
         }
     } failure:^(NSError *error, NSInteger statusCode) {
         if(failure)
         {
             failure(error, statusCode);
         }
     }];
}


- (void)unlikeMedia:(NSString *)mediaId
        withSuccess:(dispatch_block_t)success
            failure:(InstagramFailureBlock)failure
{
    [self deletePath:[NSString stringWithFormat:@"media/%@/likes",mediaId] parameters:nil responseModel:nil success:^{
        if(success)
		{
			success();
		}
    } failure:^(NSError *error, NSInteger statusCode) {
        if(failure)
		{
			failure(error, statusCode);
		}
    }];
}


#pragma mark - Relationships -


- (void)getRelationshipStatusOfUser:(NSString *)userId
                        withSuccess:(InstagramResponseBlock)success
                            failure:(InstagramFailureBlock)failure
{
    [self getPath:[NSString stringWithFormat:@"users/%@/relationship",userId] parameters:nil responseModel:[NSDictionary class] success:^(id response, InstagramPaginationInfo *paginationInfo) {
        if(success)
		{
			NSDictionary *responseDictionary = response;
			success(responseDictionary);
		}
    } failure:^(NSError *error, NSInteger statusCode) {
        if(failure)
		{
			failure(error, statusCode);
		}
    }];
}


- (void)getUsersFollowedByUser:(NSString *)userId
                   withSuccess:(InstagramObjectsBlock)success
                       failure:(InstagramFailureBlock)failure
{
    [self getPath:[NSString stringWithFormat:@"users/%@/follows",userId] parameters:nil responseModel:[InstagramUser class] success:^(id response, InstagramPaginationInfo *paginationInfo) {
        if(success)
		{
			NSArray *objects = response;
			success(objects, paginationInfo);
		}
    } failure:^(NSError *error, NSInteger statusCode) {
        if(failure)
		{
			failure(error, statusCode);
		}
    }];
}


- (void)getFollowersOfUser:(NSString *)userId
               withSuccess:(InstagramObjectsBlock)success
                   failure:(InstagramFailureBlock)failure
{
    [self getPath:[NSString stringWithFormat:@"users/%@/followed-by",userId] parameters:nil responseModel:[InstagramUser class] success:^(id response, InstagramPaginationInfo *paginationInfo) {
        if(success)
		{
			NSArray *objects = response;
			success(objects, paginationInfo);
		}
    } failure:^(NSError *error, NSInteger statusCode) {
        if(failure)
		{
			failure(error, statusCode);
		}
    }];
}


- (void)getFollowRequestsWithSuccess:(InstagramObjectsBlock)success
                             failure:(InstagramFailureBlock)failure
{
    [self getPath:[NSString stringWithFormat:@"users/self/requested-by"] parameters:nil responseModel:[InstagramUser class] success:^(id response, InstagramPaginationInfo *paginationInfo) {
        if(success)
		{
			NSArray *objects = response;
			success(objects, paginationInfo);
		}
    } failure:^(NSError *error, NSInteger statusCode) {
        if(failure)
		{
			failure(error, statusCode);
		}
    }];
}


- (void)followUser:(NSString *)userId
       withSuccess:(InstagramResponseBlock)success
           failure:(InstagramFailureBlock)failure
{
    NSDictionary *params = @{kRelationshipActionKey:kRelationshipActionFollow};
    [self postPath:[NSString stringWithFormat:@"users/%@/relationship",userId] parameters:params responseModel:nil success:^(NSDictionary *responseObject)
    {
        if(success)
		{
			success(responseObject);
		}
    } failure:^(NSError *error, NSInteger statusCode) {
                if(failure)
		{
			failure(error, statusCode);
		}
        NSLog(@"%@", [error description]);
    }];
}


- (void)unfollowUser:(NSString *)userId
         withSuccess:(InstagramResponseBlock)success
             failure:(InstagramFailureBlock)failure
{
    NSDictionary *params = @{kRelationshipActionKey:kRelationshipActionUnfollow};
    [self postPath:[NSString stringWithFormat:@"users/%@/relationship",userId] parameters:params responseModel:nil success:^(NSDictionary *responseObject)
    {
        if(success)
		{
			success(responseObject);
		}
    } failure:^(NSError *error, NSInteger statusCode) {
                if(failure)
		{
			failure(error, statusCode);
		}
        NSLog(@"%@", [error description]);
    }];
}


- (void)blockUser:(NSString *)userId
      withSuccess:(InstagramResponseBlock)success
          failure:(InstagramFailureBlock)failure
{
    NSDictionary *params = @{kRelationshipActionKey:kRelationshipActionBlock};
    [self postPath:[NSString stringWithFormat:@"users/%@/relationship",userId] parameters:params responseModel:nil success:^(NSDictionary *responseObject)
    {
        if(success)
		{
			success(responseObject);
		}
    } failure:^(NSError *error, NSInteger statusCode) {
                if(failure)
		{
			failure(error, statusCode);
		}
        NSLog(@"%@", [error description]);
    }];
}


- (void)unblockUser:(NSString *)userId
        withSuccess:(InstagramResponseBlock)success
            failure:(InstagramFailureBlock)failure
{
    NSDictionary *params = @{kRelationshipActionKey:kRelationshipActionUnblock};
    [self postPath:[NSString stringWithFormat:@"users/%@/relationship",userId] parameters:params responseModel:nil success:^(NSDictionary *responseObject)
    {
        if(success)
		{
			success(responseObject);
		}
    } failure:^(NSError *error, NSInteger statusCode) {
                if(failure)
		{
			failure(error, statusCode);
		}
        NSLog(@"%@", [error description]);
    }];
}


- (void)approveUser:(NSString *)userId
        withSuccess:(InstagramResponseBlock)success
            failure:(InstagramFailureBlock)failure
{
    NSDictionary *params = @{kRelationshipActionKey:kRelationshipActionApprove};
    [self postPath:[NSString stringWithFormat:@"users/%@/relationship",userId] parameters:params responseModel:nil success:^(NSDictionary *responseObject)
    {
        if(success)
		{
			success(responseObject);
		}
    } failure:^(NSError *error, NSInteger statusCode) {
                if(failure)
		{
			failure(error, statusCode);
		}
        NSLog(@"%@", [error description]);
    }];
}


- (void)denyUser:(NSString *)userId
     withSuccess:(InstagramResponseBlock)success
         failure:(InstagramFailureBlock)failure
{
    NSDictionary *params = @{kRelationshipActionKey:kRelationshipActionDeny};
    [self postPath:[NSString stringWithFormat:@"users/%@/relationship",userId] parameters:params responseModel:nil success:^(NSDictionary *responseObject) {
        if(success)
		{
			success(responseObject);
		}
    } failure:^(NSError *error, NSInteger statusCode) {
                if(failure)
		{
			failure(error, statusCode);
		}
        NSLog(@"%@", [error description]);
    }];
}


#pragma mark - Pagination -


- (void)getPaginatedItemsForInfo:(InstagramPaginationInfo *)paginationInfo
                     withSuccess:(InstagramObjectsBlock)success
                         failure:(InstagramFailureBlock)failure
{
    NSString *relativePath = [[paginationInfo.nextURL absoluteString] stringByReplacingOccurrencesOfString:[self.httpManager.baseURL absoluteString] withString:@""];
    [self getPath:relativePath parameters:nil responseModel:paginationInfo.type success:^(id response, InstagramPaginationInfo *paginationInfo) {

		if(success)
		{
			NSArray *objects = response;
			success(objects, paginationInfo);
		}

    } failure:^(NSError *error, NSInteger statusCode) {

		if(failure)
		{
			failure(error, statusCode);
		}
		
    }];
}


@end
