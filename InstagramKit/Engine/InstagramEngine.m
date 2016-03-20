//
//    Copyright (c) 2015 Shyam Bhat
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

#if INSTAGRAMKIT_UICKEYCHAINSTORE
#import "UICKeyChainStore.h"
#endif

@interface InstagramEngine()

@property (nonatomic, copy, nonnull) NSString *appClientID;
@property (nonatomic, copy, nonnull) NSString *appRedirectURL;
@property (nonatomic, strong, nonnull) AFHTTPSessionManager *httpManager;

#if INSTAGRAMKIT_UICKEYCHAINSTORE
@property (nonatomic, strong, nonnull) UICKeyChainStore *keychainStore;
#endif

@end


@implementation InstagramEngine


#pragma mark - Initializers -


+ (instancetype)sharedEngine {
    static InstagramEngine *_sharedEngine = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sharedEngine = [[InstagramEngine alloc] init];
    });
    return _sharedEngine;
}


- (instancetype)init {
    
    if (self = [super init])
    {
        NSURL *baseURL = [NSURL URLWithString:kInstagramKitBaseURL];
        self.httpManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
        self.httpManager.responseSerializer = [[AFJSONResponseSerializer alloc] init];

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


#pragma mark -


- (void)setAccessToken:(NSString *)accessToken
{
    _accessToken = accessToken;
    
#if INSTAGRAMKIT_UICKEYCHAINSTORE
    self.keychainStore[kKeychainTokenKey] = self.accessToken;
#endif
    
    [[NSNotificationCenter defaultCenter] postNotificationName:InstagramKitUserAuthenticationChangedNotification object:nil];
}


#pragma mark - Authentication -


- (NSURL *)authorizationURL
{
    return [self authorizationURLForScope:InstagramKitLoginScopeBasic];
}


- (NSURL *)authorizationURLForScope:(InstagramKitLoginScope)scope
{
    NSDictionary *parameters = [self authorizationParametersWithScope:scope];
    NSURLRequest *authRequest = (NSURLRequest *)[[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:kInstagramKitAuthorizationURL parameters:parameters error:nil];
    return authRequest.URL;
}


- (BOOL)receivedValidAccessTokenFromURL:(NSURL *)url
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
        self.accessToken = token;
    }
    else {
        NSString *localizedDescription = NSLocalizedString(@"Authorization not granted.", @"Error notification to indicate Instagram OAuth token was not provided.");
        *error = [NSError errorWithDomain:InstagramKitErrorDomain
                                     code:InstagramKitAuthenticationFailedError
                                 userInfo:@{NSLocalizedDescriptionKey: localizedDescription}];
    }
    return success;
}


- (BOOL)isSessionValid
{
    return self.accessToken != nil;
}


- (void)logout
{    
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [[storage cookies] enumerateObjectsUsingBlock:^(NSHTTPCookie *cookie, NSUInteger idx, BOOL *stop) {
        [storage deleteCookie:cookie];
    }];
    
    self.accessToken = nil;
}


#pragma mark -


- (NSDictionary *)authorizationParametersWithScope:(InstagramKitLoginScope)scope
{
    NSString *scopeString = [self stringForScope:scope];
    NSDictionary *parameters = @{ @"client_id": self.appClientID,
                                  @"redirect_uri": self.appRedirectURL,
                                  @"response_type": @"token",
                                  @"scope": scopeString };
    return parameters;
}


- (NSString *)stringForScope:(InstagramKitLoginScope)scope
{
    NSArray *typeStrings = @[@"basic", @"comments", @"relationships", @"likes", @"public_content", @"follower_list"];
    
    NSMutableArray *strings = [NSMutableArray arrayWithCapacity:typeStrings.count];
    [typeStrings enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSUInteger enumBitValueToCheck = 1 << idx;
        (scope & enumBitValueToCheck) ? [strings addObject:obj] : 0;
    }];
    
    return (strings.count) ? [strings componentsJoinedByString:@" "] : typeStrings[0];
}


- (NSDictionary *)queryStringParametersFromString:(NSString*)string {

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [[string componentsSeparatedByString:@"&"] enumerateObjectsUsingBlock:^(NSString * param, NSUInteger idx, BOOL *stop) {
        NSArray *pairs = [param componentsSeparatedByString:@"="];
        if ([pairs count] != 2) return;
        
        NSString *key = [pairs[0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *value = [pairs[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        // Must manually clean when passed string is url.resourceSpecifier
        if ([[key substringToIndex:1] isEqualToString: @"#"]) {
            key = [key substringFromIndex:1];
        }
        
        [dict setObject:value forKey:key];
    }];
    return dict;
}


- (NSDictionary *)dictionaryWithAccessTokenAndParameters:(NSDictionary *)params
{
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:params];
    if (self.accessToken) {
        [mutableDictionary setObject:self.accessToken forKey:kKeyAccessToken];
    }
    else
    {
        [mutableDictionary setObject:self.appClientID forKey:kKeyClientID];
    }
    return [NSDictionary dictionaryWithDictionary:mutableDictionary];
}


- (NSDictionary *)parametersFromCount:(NSInteger)count maxId:(NSString *)maxId andPaginationKey:(NSString *)key
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (count) {
        [params setObject:[NSString stringWithFormat:@"%ld",(long)count] forKey:kCount];
    }
    if (maxId) {
        [params setObject:maxId forKey:key];
    }
    return [params copy];
}


#pragma mark - Base Calls -


- (void)getPath:(NSString *)path
     parameters:(NSDictionary *)parameters
  responseModel:(Class)modelClass
        success:(InstagramObjectBlock)success
        failure:(InstagramFailureBlock)failure
{
    NSDictionary *params = [self dictionaryWithAccessTokenAndParameters:parameters];
    NSString *percentageEscapedPath = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.httpManager GET:percentageEscapedPath
               parameters:params
                 progress:nil
                  success:^(NSURLSessionDataTask *task, id responseObject) {
                      if (!success) return;
                      NSDictionary *responseDictionary = (NSDictionary *)responseObject;
                      NSDictionary *dataDictionary = IKNotNull(responseDictionary[kData]) ? responseDictionary[kData] : nil;
                      id modelObject =  (modelClass == [NSDictionary class]) ? [dataDictionary copy] : [[modelClass alloc] initWithInfo:dataDictionary];
                      success(modelObject);
                  }
                  failure:^(NSURLSessionDataTask *task, NSError *error) {
                      (failure)? failure(error, ((NSHTTPURLResponse *)[task response]).statusCode) : 0;
                  }];
}


- (void)getPaginatedPath:(NSString *)path
              parameters:(NSDictionary *)parameters
           responseModel:(Class)modelClass
                 success:(InstagramPaginatiedResponseBlock)success
                 failure:(InstagramFailureBlock)failure
{
    NSDictionary *params = [self dictionaryWithAccessTokenAndParameters:parameters];
    NSString *percentageEscapedPath = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.httpManager GET:percentageEscapedPath
               parameters:params
                 progress:nil
                  success:^(NSURLSessionDataTask *task, id responseObject) {
                      if (!success) return;
                      NSDictionary *responseDictionary = (NSDictionary *)responseObject;
                      
                      NSDictionary *pInfo = responseDictionary[kPagination];
                      InstagramPaginationInfo *paginationInfo = IKNotNull(pInfo)?[[InstagramPaginationInfo alloc] initWithInfo:pInfo andObjectType:modelClass]: nil;
                      
                      NSArray *responseObjects = IKNotNull(responseDictionary[kData]) ? responseDictionary[kData] : nil;
                      NSMutableArray *objects = [NSMutableArray arrayWithCapacity:responseObjects.count];
                      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                          [responseObjects enumerateObjectsUsingBlock:^(NSDictionary * dataDictionary, NSUInteger idx, BOOL *stop) {
                              id modelObject = [[modelClass alloc] initWithInfo:dataDictionary];
                              [objects addObject:modelObject];
                          }];
                          dispatch_async(dispatch_get_main_queue(), ^{
                              success([objects copy], paginationInfo);
                          });
                      });
                  }
                  failure:^(NSURLSessionDataTask *task, NSError *error) {
                      (failure)? failure(error, ((NSHTTPURLResponse *)[task response]).statusCode) : 0;
                  }];
}


- (void)postPath:(NSString *)path
      parameters:(NSDictionary *)parameters
         success:(InstagramResponseBlock)success
         failure:(InstagramFailureBlock)failure
{
    NSDictionary *params = [self dictionaryWithAccessTokenAndParameters:parameters];
    [self.httpManager POST:path
                parameters:params
                  progress:nil
                   success:^(NSURLSessionDataTask *task, id responseObject) {
                       (success)? success((NSDictionary *)responseObject) : 0;
                   }
                   failure:^(NSURLSessionDataTask *task, NSError *error) {
                       (failure) ? failure(error,((NSHTTPURLResponse*)[task response]).statusCode) : 0;
                   }];
}


- (void)deletePath:(NSString *)path
      parameters:(NSDictionary *)parameters
           success:(InstagramResponseBlock)success
           failure:(InstagramFailureBlock)failure
{
    NSDictionary *params = [self dictionaryWithAccessTokenAndParameters:parameters];
    [self.httpManager DELETE:path
                  parameters:params
                     success:^(NSURLSessionDataTask *task, id responseObject) {
                         (success)? success((NSDictionary *)responseObject) : 0;
                     }
                     failure:^(NSURLSessionDataTask *task, NSError *error) {
                         (failure) ? failure(error,((NSHTTPURLResponse*)[task response]).statusCode) : 0;
                     }];
}


#pragma mark - Media -


- (void)getMedia:(NSString *)mediaId
     withSuccess:(InstagramMediaObjectBlock)success
         failure:(InstagramFailureBlock)failure
{
    [self getPath:[NSString stringWithFormat:@"media/%@",mediaId]
       parameters:nil
    responseModel:[InstagramMedia class]
          success:success
          failure:failure];
}


- (void)getPopularMediaWithSuccess:(InstagramMediaBlock)success
                           failure:(InstagramFailureBlock)failure
{
    [self getPaginatedPath:@"media/popular"
                parameters:nil
             responseModel:[InstagramMedia class]
                   success:success
                   failure:failure];
}


- (void)getMediaAtLocation:(CLLocationCoordinate2D)location
               withSuccess:(InstagramMediaBlock)success
                   failure:(InstagramFailureBlock)failure
{
    [self getMediaAtLocation:location
                       count:0
                       maxId:nil
                    distance:1000
                 withSuccess:success
                     failure:failure];
}


- (void)getMediaAtLocation:(CLLocationCoordinate2D)location
                     count:(NSInteger)count
                     maxId:(NSString *)maxId
                  distance:(CGFloat)distance
               withSuccess:(InstagramMediaBlock)success
                   failure:(InstagramFailureBlock)failure
{
    NSDictionary *params = [self parametersFromCount:count maxId:maxId andPaginationKey:kPaginationKeyMaxId];
    [self getPaginatedPath:[NSString stringWithFormat:@"media/search?lat=%f&lng=%f&distance=%f",location.latitude,location.longitude, distance]
                parameters:params
             responseModel:[InstagramMedia class]
                   success:success
                   failure:failure];
}

- (void)getMediaAtLocationWithId:(NSString*)locationId
                     withSuccess:(InstagramMediaBlock)success
                         failure:(InstagramFailureBlock)failure
{
    [self getPaginatedPath:[NSString stringWithFormat:@"locations/%@/media/recent", locationId]
                parameters:nil
             responseModel:[InstagramMedia class]
                   success:success
                   failure:failure];
}


#pragma mark - Locations -


- (void)searchLocationsAtLocation:(CLLocationCoordinate2D)loction
                       withSuccess:(InstagramLocationsBlock)success
                           failure:(InstagramFailureBlock)failure
{
     [self getPaginatedPath:[NSString stringWithFormat:@"locations/search?lat=%f&lng=%f", loction.latitude, loction.longitude]
                 parameters:nil
              responseModel:[InstagramLocation class]
                    success:success
                    failure:failure];
}


- (void)searchLocationsAtLocation:(CLLocationCoordinate2D)loction
                     distanceInMeters:(NSInteger)distance
                     withSuccess:(InstagramLocationsBlock)success
                     failure:(InstagramFailureBlock)failure
{
     [self getPaginatedPath:[NSString stringWithFormat:@"locations/search?lat=%f&lng=%f&distance=%ld", loction.latitude, loction.longitude, (long)distance]
                 parameters:nil
              responseModel:[InstagramLocation class]
                    success:success
                    failure:failure];
}
                         

- (void)getLocationWithId:(NSString*)locationId
                     withSuccess:(InstagramLocationBlock)success
                     failure:(InstagramFailureBlock)failure
 {
     [self getPath:[NSString stringWithFormat:@"locations/%@", locationId]
        parameters:nil
     responseModel:[InstagramLocation class]
           success:success
           failure:failure];
 }
                         


#pragma mark - Users -


- (void)getUserDetails:(NSString *)userId
           withSuccess:(InstagramUserBlock)success
               failure:(InstagramFailureBlock)failure
{
    [self getPath:[NSString stringWithFormat:@"users/%@",userId]
       parameters:nil
    responseModel:[InstagramUser class]
          success:success
          failure:failure];
}


- (void)getMediaForUser:(NSString *)userId
            withSuccess:(InstagramMediaBlock)success
                failure:(InstagramFailureBlock)failure
{
    [self getMediaForUser:userId
                    count:0
                    maxId:nil
              withSuccess:success
                  failure:failure];
}


- (void)getMediaForUser:(NSString *)userId
                  count:(NSInteger)count
                  maxId:(NSString *)maxId
            withSuccess:(InstagramMediaBlock)success
                failure:(InstagramFailureBlock)failure
{
    NSDictionary *params = [self parametersFromCount:count
                                               maxId:maxId
                                    andPaginationKey:kPaginationKeyMaxId];
    [self getPaginatedPath:[NSString stringWithFormat:@"users/%@/media/recent",userId]
                parameters:params
             responseModel:[InstagramMedia class]
                   success:success
                   failure:failure];
}


- (void)searchUsersWithString:(NSString *)name
                  withSuccess:(InstagramUsersBlock)success
                      failure:(InstagramFailureBlock)failure
{
    [self getPaginatedPath:[NSString stringWithFormat:@"users/search?q=%@",name]
                parameters:nil
             responseModel:[InstagramUser class]
                   success:success
                   failure:failure];
}


#pragma mark - Self -


- (void)getSelfUserDetailsWithSuccess:(InstagramUserBlock)success
                              failure:(InstagramFailureBlock)failure
{
    [self getPath:@"users/self"
       parameters:nil
    responseModel:[InstagramUser class]
          success:success
          failure:failure];
}


- (void)getSelfFeedWithSuccess:(InstagramMediaBlock)success
                       failure:(InstagramFailureBlock)failure
{
    [self getSelfFeedWithCount:0
                         maxId:nil
                       success:success
                       failure:failure];
}


- (void)getSelfFeedWithCount:(NSInteger)count
                       maxId:(NSString *)maxId
                     success:(InstagramMediaBlock)success
                     failure:(InstagramFailureBlock)failure
{
    NSDictionary *params = [self parametersFromCount:count maxId:maxId andPaginationKey:kPaginationKeyMaxId];
    [self getPaginatedPath:[NSString stringWithFormat:@"users/self/feed"]
                parameters:params
             responseModel:[InstagramMedia class]
                   success:success
                   failure:failure];
}


- (void)getMediaLikedBySelfWithSuccess:(InstagramMediaBlock)success
                               failure:(InstagramFailureBlock)failure
{
    [self getMediaLikedBySelfWithCount:0
                                 maxId:nil
                               success:success
                               failure:failure];
}


- (void)getMediaLikedBySelfWithCount:(NSInteger)count
                               maxId:(NSString *)maxId
                             success:(InstagramMediaBlock)success
                             failure:(InstagramFailureBlock)failure
{
    NSDictionary *params = [self parametersFromCount:count
                                               maxId:maxId
                                    andPaginationKey:kPaginationKeyMaxLikeId];
    [self getPaginatedPath:[NSString stringWithFormat:@"users/self/media/liked"]
                parameters:params
             responseModel:[InstagramMedia class]
                   success:success
                   failure:failure];
}

- (void)getSelfRecentMediaWithSuccess:(InstagramMediaBlock)success
							  failure:(InstagramFailureBlock)failure
{
    [self getSelfRecentMediaWithCount:0
                                maxId:nil
                              success:success
                              failure:failure];
}


- (void)getSelfRecentMediaWithCount:(NSInteger)count
                              maxId:(NSString *)maxId
                            success:(InstagramMediaBlock)success
                            failure:(InstagramFailureBlock)failure
{
    NSDictionary *params = [self parametersFromCount:count
                                               maxId:maxId
                                    andPaginationKey:kPaginationKeyMaxId];
	[self getPaginatedPath:[NSString stringWithFormat:@"users/self/media/recent"]
                parameters:params
             responseModel:[InstagramMedia class]
                   success:success
                   failure:failure];
}

#pragma mark - Tags -


- (void)getTagDetailsWithName:(NSString *)name
                  withSuccess:(InstagramTagBlock)success
                      failure:(InstagramFailureBlock)failure
{
    [self getPath:[NSString stringWithFormat:@"tags/%@",name]
       parameters:nil
    responseModel:[InstagramTag class]
          success:success
          failure:failure];
}


- (void)getMediaWithTagName:(NSString *)name
                withSuccess:(InstagramMediaBlock)success
                    failure:(InstagramFailureBlock)failure
{
    [self getMediaWithTagName:name
                        count:0
                        maxId:nil
                  withSuccess:success
                      failure:failure];
}


- (void)getMediaWithTagName:(NSString *)tag
                      count:(NSInteger)count
                      maxId:(NSString *)maxId
                withSuccess:(InstagramMediaBlock)success
                    failure:(InstagramFailureBlock)failure
{
    NSDictionary *params = [self parametersFromCount:count maxId:maxId andPaginationKey:kPaginationKeyMaxTagId];
    [self getPaginatedPath:[NSString stringWithFormat:@"tags/%@/media/recent",tag]
                parameters:params
             responseModel:[InstagramMedia class]
                   success:success
                   failure:failure];
}


- (void)searchTagsWithName:(NSString *)name
               withSuccess:(InstagramTagsBlock)success
                   failure:(InstagramFailureBlock)failure
{
    [self searchTagsWithName:name
                       count:0
                       maxId:nil
                 withSuccess:success
                     failure:failure];
}


- (void)searchTagsWithName:(NSString *)name
                     count:(NSInteger)count
                     maxId:(NSString *)maxId
               withSuccess:(InstagramTagsBlock)success
                   failure:(InstagramFailureBlock)failure
{
    NSDictionary *params = [self parametersFromCount:count maxId:maxId andPaginationKey:kPaginationKeyMaxId];
    [self getPaginatedPath:[NSString stringWithFormat:@"tags/search?q=%@",name]
                parameters:params
             responseModel:[InstagramTag class]
                   success:success
                   failure:failure];
}


#pragma mark - Comments -


- (void)getCommentsOnMedia:(NSString *)mediaId
               withSuccess:(InstagramCommentsBlock)success
                   failure:(InstagramFailureBlock)failure
{
    [self getPaginatedPath:[NSString stringWithFormat:@"media/%@/comments",mediaId]
                parameters:nil
             responseModel:[InstagramComment class]
                   success:success
                   failure:failure];
}


- (void)createComment:(NSString *)commentText
              onMedia:(NSString *)mediaId
          withSuccess:(InstagramResponseBlock)success
              failure:(InstagramFailureBlock)failure
{
    NSDictionary *params = [NSDictionary dictionaryWithObjects:@[commentText] forKeys:@[@"text"]];
    [self postPath:[NSString stringWithFormat:@"media/%@/comments",mediaId]
        parameters:params
           success:success
           failure:failure];
}


- (void)removeComment:(NSString *)commentId
              onMedia:(NSString *)mediaId
          withSuccess:(InstagramResponseBlock)success
              failure:(InstagramFailureBlock)failure
{
    [self deletePath:[NSString stringWithFormat:@"media/%@/comments/%@",mediaId,commentId]
          parameters:nil
               success:success
             failure:failure];
}


#pragma mark - Likes -


- (void)getLikesOnMedia:(NSString *)mediaId
            withSuccess:(InstagramUsersBlock)success
                failure:(InstagramFailureBlock)failure
{
    [self getPaginatedPath:[NSString stringWithFormat:@"media/%@/likes",mediaId]
                parameters:nil
             responseModel:[InstagramUser class]
                   success:success
                   failure:failure];
}


- (void)likeMedia:(NSString *)mediaId
      withSuccess:(InstagramResponseBlock)success
          failure:(InstagramFailureBlock)failure
{
    [self postPath:[NSString stringWithFormat:@"media/%@/likes",mediaId]
        parameters:nil
           success:success
           failure:failure];
}


- (void)unlikeMedia:(NSString *)mediaId
        withSuccess:(InstagramResponseBlock)success
            failure:(InstagramFailureBlock)failure
{
    [self deletePath:[NSString stringWithFormat:@"media/%@/likes",mediaId]
          parameters:nil
               success:success
             failure:failure];
}


#pragma mark - Relationships -


- (void)getRelationshipStatusOfUser:(NSString *)userId
                        withSuccess:(InstagramResponseBlock)success
                            failure:(InstagramFailureBlock)failure
{
    [self getPath:[NSString stringWithFormat:@"users/%@/relationship",userId]
       parameters:nil
    responseModel:[NSDictionary class]
          success:success
          failure:failure];
}


- (void)getUsersFollowedByUser:(NSString *)userId
                   withSuccess:(InstagramUsersBlock)success
                       failure:(InstagramFailureBlock)failure
{
    [self getPaginatedPath:[NSString stringWithFormat:@"users/%@/follows",userId]
                parameters:nil
             responseModel:[InstagramUser class]
                   success:success
                   failure:failure];
}


- (void)getFollowersOfUser:(NSString *)userId
               withSuccess:(InstagramUsersBlock)success
                   failure:(InstagramFailureBlock)failure
{
    [self getPaginatedPath:[NSString stringWithFormat:@"users/%@/followed-by",userId]
                parameters:nil
             responseModel:[InstagramUser class]
                   success:success
                   failure:failure];
}


- (void)getFollowRequestsWithSuccess:(InstagramUsersBlock)success
                             failure:(InstagramFailureBlock)failure
{
    [self getPaginatedPath:[NSString stringWithFormat:@"users/self/requested-by"]
                parameters:nil
             responseModel:[InstagramUser class]
                   success:success
                   failure:failure];
}


- (void)followUser:(NSString *)userId
       withSuccess:(InstagramResponseBlock)success
           failure:(InstagramFailureBlock)failure
{
    NSDictionary *params = @{kRelationshipActionKey:kRelationshipActionFollow};
    [self postPath:[NSString stringWithFormat:@"users/%@/relationship",userId]
        parameters:params
           success:success
           failure:failure];
}


- (void)unfollowUser:(NSString *)userId
         withSuccess:(InstagramResponseBlock)success
             failure:(InstagramFailureBlock)failure
{
    NSDictionary *params = @{kRelationshipActionKey:kRelationshipActionUnfollow};
    [self postPath:[NSString stringWithFormat:@"users/%@/relationship",userId]
        parameters:params
           success:success
           failure:failure];
}


- (void)blockUser:(NSString *)userId
      withSuccess:(InstagramResponseBlock)success
          failure:(InstagramFailureBlock)failure
{
    NSDictionary *params = @{kRelationshipActionKey:kRelationshipActionBlock};
    [self postPath:[NSString stringWithFormat:@"users/%@/relationship",userId]
        parameters:params
           success:success
           failure:failure];
}


- (void)unblockUser:(NSString *)userId
        withSuccess:(InstagramResponseBlock)success
            failure:(InstagramFailureBlock)failure
{
    NSDictionary *params = @{kRelationshipActionKey:kRelationshipActionUnblock};
    [self postPath:[NSString stringWithFormat:@"users/%@/relationship",userId]
        parameters:params
           success:success
           failure:failure];
}


- (void)approveUser:(NSString *)userId
        withSuccess:(InstagramResponseBlock)success
            failure:(InstagramFailureBlock)failure
{
    NSDictionary *params = @{kRelationshipActionKey:kRelationshipActionApprove};
    [self postPath:[NSString stringWithFormat:@"users/%@/relationship",userId]
        parameters:params
           success:success
           failure:failure];
}


- (void)ignoreUser:(NSString *)userId
     withSuccess:(InstagramResponseBlock)success
         failure:(InstagramFailureBlock)failure
{
    NSDictionary *params = @{kRelationshipActionKey:kRelationshipActionIgnore};
    [self postPath:[NSString stringWithFormat:@"users/%@/relationship",userId]
        parameters:params
           success:success
           failure:failure];
}


#pragma mark - Pagination -


- (void)getPaginatedItemsForInfo:(InstagramPaginationInfo *)paginationInfo
                     withSuccess:(InstagramPaginatiedResponseBlock)success
                         failure:(InstagramFailureBlock)failure
{
    NSString *relativePath = [[paginationInfo.nextURL absoluteString] stringByReplacingOccurrencesOfString:[self.httpManager.baseURL absoluteString] withString:@""];
    relativePath = [relativePath stringByRemovingPercentEncoding];
    [self getPaginatedPath:relativePath
                parameters:nil
             responseModel:paginationInfo.type
                   success:success
                   failure:failure];
}


@end
