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

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void(^InstagramLoginBlock)(NSError* error);

extern NSString *const kInstagramKitAppClientIdConfigurationKey;
extern NSString *const kInstagramKitAppRedirectUrlConfigurationKey;

extern NSString *const kInstagramKitBaseUrlConfigurationKey;
extern NSString *const kInstagramKitAuthorizationUrlConfigurationKey;

extern NSString *const kInstagramKitBaseUrl __deprecated;
extern NSString *const kInstagramKitAuthorizationUrl __deprecated;

// Head over to http://instagram.com/developer/clients/manage/ to find these.

@class InstagramUser;
@class InstagramMedia;
@class InstagramPaginationInfo;
@class InstagramTag;

extern NSString *const kInstagramKitErrorDomain;

typedef enum
{
    // Indicates no error
    kInstagramKitErrorCodeNone,

    // Indicates that the access was not granted.  This happens when the instagram kit
    // is not able to obtain an access_token
    kInstagramKitErrorCodeAccessNotGranted,

    // And finally some code that are blatently plagerized from the core API
    kInstagramKitErrorCodeUserCancelled = NSUserCancelledError,

} InstagramErrorCode;

@interface InstagramEngine : NSObject

+ (InstagramEngine *)sharedEngine;
+ (NSDictionary*) sharedEngineConfiguration;

@property (nonatomic, copy) NSString *appClientID;
@property (nonatomic, copy) NSString *appRedirectURL;
@property (nonatomic, copy) NSString *authorizationURL;

@property (nonatomic, copy) NSString *accessToken;

#pragma mark - Login -

- (void)loginWithBlock:(InstagramLoginBlock)block;

- (void)cancelLogin;

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            sourceApplication:(NSString *)
            sourceApplication
            annotation:(id)annotation;



#pragma mark - Media -


- (void)getMedia:(NSString *)mediaId
     withSuccess:(void (^)(InstagramMedia *media))success
         failure:(void (^)(NSError* error))failure;




- (void)getPopularMediaWithSuccess:(void (^)(NSArray *media, InstagramPaginationInfo *paginationInfo))success
                           failure:(void (^)(NSError* error))failure;




- (void)getMediaAtLocation:(CLLocationCoordinate2D)location
               withSuccess:(void (^)(NSArray *media, InstagramPaginationInfo *paginationInfo))success
                   failure:(void (^)(NSError* error))failure;

- (void)getMediaAtLocation:(CLLocationCoordinate2D)location count:(NSInteger)count maxId:(NSString *)maxId
               withSuccess:(void (^)(NSArray *media, InstagramPaginationInfo *paginationInfo))success
                   failure:(void (^)(NSError* error))failure;


#pragma mark - Users -


- (void)getUserDetails:(InstagramUser *)user
           withSuccess:(void (^)(InstagramUser *userDetail))success
               failure:(void (^)(NSError* error))failure;




- (void)getMediaForUser:(NSString *)userId
        withSuccess:(void (^)(NSArray *feed, InstagramPaginationInfo *paginationInfo))success
            failure:(void (^)(NSError* error))failure;

- (void)getMediaForUser:(NSString *)userId count:(NSInteger)count maxId:(NSString *)maxId
            withSuccess:(void (^)(NSArray *feed, InstagramPaginationInfo *paginationInfo))success
                failure:(void (^)(NSError* error))failure;




- (void)searchUsersWithString:(NSString *)string
                  withSuccess:(void (^)(NSArray *users, InstagramPaginationInfo *paginationInfo))success
                      failure:(void (^)(NSError* error))failure;


#pragma mark - Self User -


- (void)getSelfUserDetailsWithSuccess:(void (^)(InstagramUser *userDetail))success
                              failure:(void (^)(NSError* error))failure;




- (void)getSelfFeedWithSuccess:(void (^)(NSArray *feed, InstagramPaginationInfo *paginationInfo))success
            failure:(void (^)(NSError* error))failure;

- (void)getSelfFeedWithCount:(NSInteger)count maxId:(NSString *)maxId
        success:(void (^)(NSArray *feed, InstagramPaginationInfo *paginationInfo))success
            failure:(void (^)(NSError* error))failure;




- (void)getMediaLikedBySelfWithSuccess:(void (^)(NSArray *feed, InstagramPaginationInfo *paginationInfo))success
                        failure:(void (^)(NSError* error))failure;

- (void)getMediaLikedBySelfWithCount:(NSInteger)count maxId:(NSString *)maxId
                             success:(void (^)(NSArray *feed, InstagramPaginationInfo *paginationInfo))success
                               failure:(void (^)(NSError* error))failure;


#pragma mark - Tags -


- (void)getTagDetailsWithName:(NSString *)name
                  withSuccess:(void (^)(InstagramTag *tag))success
                      failure:(void (^)(NSError* error))failure;




- (void)getMediaWithTagName:(NSString *)tag
            withSuccess:(void (^)(NSArray *feed, InstagramPaginationInfo *paginationInfo))success
                failure:(void (^)(NSError* error))failure;

- (void)getMediaWithTagName:(NSString *)tag count:(NSInteger)count maxId:(NSString *)maxId
                withSuccess:(void (^)(NSArray *feed, InstagramPaginationInfo *paginationInfo))success
                    failure:(void (^)(NSError* error))failure;




- (void)searchTagsWithName:(NSString *)name
               withSuccess:(void (^)(NSArray *tags, InstagramPaginationInfo *paginationInfo))success
                   failure:(void (^)(NSError* error))failure;

- (void)searchTagsWithName:(NSString *)name count:(NSInteger)count maxId:(NSString *)maxId
               withSuccess:(void (^)(NSArray *tags, InstagramPaginationInfo *paginationInfo))success
                   failure:(void (^)(NSError* error))failure;


#pragma mark - Comments -


- (void)getCommentsOnMedia:(InstagramMedia *)media
               withSuccess:(void (^)(NSArray *comments))success
                   failure:(void (^)(NSError* error))failure;

- (void)createComment:(NSString *)commentText
              onMedia:(InstagramMedia *)media
          withSuccess:(void (^)(void))success
              failure:(void (^)(NSError* error))failure;

- (void)removeComment:(NSString *)commentId
              onMedia:(InstagramMedia *)media
          withSuccess:(void (^)(void))success
              failure:(void (^)(NSError* error))failure;

#pragma mark - Relationships -

- (void)followUser:(InstagramUser*)user
       withSuccess:(void (^)(void))success
           failure:(void (^)(NSError* error))failure;

#pragma mark - Likes -


- (void)getLikesOnMedia:(InstagramMedia *)media
            withSuccess:(void (^)(NSArray *likedUsers))success
                failure:(void (^)(NSError* error))failure;

- (void)likeMedia:(InstagramMedia *)media
      withSuccess:(void (^)(void))success
          failure:(void (^)(NSError* error))failure;

- (void)unlikeMedia:(InstagramMedia *)media
        withSuccess:(void (^)(void))success
          failure:(void (^)(NSError* error))failure;


#pragma mark - Pagination Request -

- (void)getPaginatedItemsForInfo:(InstagramPaginationInfo *)paginationInfo
                     withSuccess:(void (^)(NSArray *media, InstagramPaginationInfo *paginationInfo))success
                         failure:(void (^)(NSError* error))failure;

@end
