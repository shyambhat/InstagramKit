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
#import <UIKit/UIKit.h>

@class InstagramUser;
@class InstagramMedia;
@class InstagramPaginationInfo;
@class InstagramTag;


typedef void (^InstagramLoginBlock)(NSError *error);
typedef void (^InstagramUserBlock)(InstagramUser *userDetail);
typedef void (^InstagramMediaDetailBlock)(InstagramMedia *media);
typedef void (^InstagramMediaBlock)(NSArray *media, InstagramPaginationInfo *paginationInfo);
typedef void (^InstagramObjectsBlock)(NSArray *objects, InstagramPaginationInfo *paginationInfo);
typedef void (^InstagramTagsBlock)(NSArray *tags, InstagramPaginationInfo *paginationInfo);
typedef void (^InstagramTagBlock)(InstagramTag *tag);
typedef void (^InstagramCommentsBlock)(NSArray *comments);
typedef void (^InstagramUsersBlock)(NSArray *users, InstagramPaginationInfo *paginationInfo);
typedef void (^InstagramResponseBlock)(NSDictionary *serverResponse);
typedef void (^InstagramFailureBlock)(NSError* error, NSInteger serverStatusCode);

extern NSString *const kInstagramKitAppClientIdConfigurationKey;
extern NSString *const kInstagramKitAppRedirectUrlConfigurationKey;

extern NSString *const kInstagramKitBaseUrlConfigurationKey;
extern NSString *const kInstagramKitAuthorizationUrlConfigurationKey;

// Head over to http://instagram.com/developer/clients/manage/ to find these.


extern NSString *const kRelationshipOutgoingStatusKey;
extern NSString *const kRelationshipOutStatusFollows;
extern NSString *const kRelationshipOutStatusRequested;
extern NSString *const kRelationshipOutStatusNone;

extern NSString *const kRelationshipIncomingStatusKey;
extern NSString *const kRelationshipInStatusFollowedBy;
extern NSString *const kRelationshipInStatusRequestedBy;
extern NSString *const kRelationshipInStatusBlockedByYou;
extern NSString *const kRelationshipInStatusNone;

extern NSString *const kRelationshipUserIsPrivateKey;

extern NSString *const kInstagramKitErrorDomain;

typedef enum
{
    kInstagramKitErrorCodeNone,
    kInstagramKitErrorCodeAccessNotGranted,
    kInstagramKitErrorCodeUserCancelled = NSUserCancelledError,
    
} InstagramKitErrorCode;

typedef NS_OPTIONS(NSInteger, IKLoginScope) {
    //    Default, to read any and all data related to a user (e.g. following/followed-by lists, photos, etc.)
    IKLoginScopeBasic = 0,
    //    to create or delete comments on a user’s behalf
    IKLoginScopeComments = 1<<1,
    //    to follow and unfollow users on a user’s behalf
    IKLoginScopeRelationships = 1<<2,
    //    to like and unlike items on a user’s behalf
    IKLoginScopeLikes = 1<<3
};

@interface InstagramEngine : NSObject

+ (InstagramEngine *)sharedEngine;
+ (NSDictionary*)sharedEngineConfiguration;

@property (nonatomic, copy) NSString *appClientID;
@property (nonatomic, copy) NSString *appRedirectURL;
@property (nonatomic, copy) NSString *authorizationURL;

@property (nonatomic, copy) NSString *accessToken;

#pragma mark - Login -

//  Comes with the basic login scope
- (void)loginWithBlock:(InstagramLoginBlock)block;
- (void)loginWithScope:(IKLoginScope)scope completionBlock:(InstagramLoginBlock)block;
+ (NSString *)stringForScope:(IKLoginScope)scope;

- (void)cancelLogin;

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)
sourceApplication
         annotation:(id)annotation;

- (void)logout;
- (BOOL)isSessionValid;

#pragma mark - Media -


- (void)getMedia:(NSString *)mediaId
     withSuccess:(InstagramMediaDetailBlock)success
         failure:(InstagramFailureBlock)failure;


- (void)getPopularMediaWithSuccess:(InstagramMediaBlock)success
                           failure:(InstagramFailureBlock)failure;

#pragma mark -


- (void)getMediaAtLocation:(CLLocationCoordinate2D)location
               withSuccess:(InstagramMediaBlock)success
                   failure:(InstagramFailureBlock)failure;

- (void)getMediaAtLocation:(CLLocationCoordinate2D)location
                     count:(NSInteger)count
                     maxId:(NSString *)maxId
               withSuccess:(InstagramMediaBlock)success
                   failure:(InstagramFailureBlock)failure;



#pragma mark - Users -


- (void)getUserDetails:(NSString *)userId
           withSuccess:(InstagramUserBlock)success
               failure:(InstagramFailureBlock)failure;

#pragma mark -


- (void)getMediaForUser:(NSString *)userId
            withSuccess:(InstagramMediaBlock)success
                failure:(InstagramFailureBlock)failure;

- (void)getMediaForUser:(NSString *)userId
                  count:(NSInteger)count
                  maxId:(NSString *)maxId
            withSuccess:(InstagramMediaBlock)success
                failure:(InstagramFailureBlock)failure;

#pragma mark -


- (void)searchUsersWithString:(NSString *)string
                  withSuccess:(InstagramUsersBlock)success
                      failure:(InstagramFailureBlock)failure;



#pragma mark - Self User -


- (void)getSelfUserDetailsWithSuccess:(InstagramUserBlock)success
                              failure:(InstagramFailureBlock)failure;

#pragma mark -


- (void)getSelfFeedWithSuccess:(InstagramMediaBlock)success
                       failure:(InstagramFailureBlock)failure;

- (void)getSelfFeedWithCount:(NSInteger)count
                       maxId:(NSString *)maxId
                     success:(InstagramMediaBlock)success
                     failure:(InstagramFailureBlock)failure;

#pragma mark -


- (void)getMediaLikedBySelfWithSuccess:(InstagramMediaBlock)success
                               failure:(InstagramFailureBlock)failure;

- (void)getMediaLikedBySelfWithCount:(NSInteger)count
                               maxId:(NSString *)maxId
                             success:(InstagramMediaBlock)success
                             failure:(InstagramFailureBlock)failure;



#pragma mark -

- (void)getSelfRecentMediaWithSuccess:(InstagramMediaBlock)success
                              failure:(InstagramFailureBlock)failure;

- (void)getSelfRecentMediaWithCount:(NSInteger)count
                              maxId:(NSString *)maxId
                            success:(InstagramMediaBlock)success
                            failure:(InstagramFailureBlock)failure;

#pragma mark - Tags -


- (void)getTagDetailsWithName:(NSString *)name
                  withSuccess:(InstagramTagBlock)success
                      failure:(InstagramFailureBlock)failure;

#pragma mark -


- (void)getMediaWithTagName:(NSString *)tag
                withSuccess:(InstagramMediaBlock)success
                    failure:(InstagramFailureBlock)failure;

- (void)getMediaWithTagName:(NSString *)tag
                      count:(NSInteger)count
                      maxId:(NSString *)maxId
                withSuccess:(InstagramMediaBlock)success
                    failure:(InstagramFailureBlock)failure;

#pragma mark -


- (void)searchTagsWithName:(NSString *)name
               withSuccess:(InstagramTagsBlock)success
                   failure:(InstagramFailureBlock)failure;

- (void)searchTagsWithName:(NSString *)name
                     count:(NSInteger)count
                     maxId:(NSString *)maxId
               withSuccess:(InstagramTagsBlock)success
                   failure:(InstagramFailureBlock)failure;



#pragma mark - Comments -


- (void)getCommentsOnMedia:(NSString *)mediaId
               withSuccess:(InstagramCommentsBlock)success
                   failure:(InstagramFailureBlock)failure;

- (void)createComment:(NSString *)commentText
              onMedia:(NSString *)mediaId
          withSuccess:(dispatch_block_t)success
              failure:(InstagramFailureBlock)failure;

- (void)removeComment:(NSString *)commentId
              onMedia:(NSString *)mediaId
          withSuccess:(dispatch_block_t)success
              failure:(InstagramFailureBlock)failure;


#pragma mark - Likes -


- (void)getLikesOnMedia:(NSString *)mediaId
            withSuccess:(InstagramObjectsBlock)success
                failure:(InstagramFailureBlock)failure;

- (void)likeMedia:(NSString *)mediaId
      withSuccess:(dispatch_block_t)success
          failure:(InstagramFailureBlock)failure;

- (void)unlikeMedia:(NSString *)mediaId
        withSuccess:(dispatch_block_t)success
            failure:(InstagramFailureBlock)failure;


#pragma mark - Relationships -


- (void)getRelationshipStatusOfUser:(NSString *)userId
                        withSuccess:(InstagramResponseBlock)success
                            failure:(InstagramFailureBlock)failure;

- (void)getUsersFollowedByUser:(NSString *)userId
                   withSuccess:(InstagramObjectsBlock)success
                       failure:(InstagramFailureBlock)failure;

- (void)getFollowersOfUser:(NSString *)userId
               withSuccess:(InstagramObjectsBlock)success
                   failure:(InstagramFailureBlock)failure;

- (void)getFollowRequestsWithSuccess:(InstagramObjectsBlock)success
                             failure:(InstagramFailureBlock)failure;

- (void)followUser:(NSString *)userId
       withSuccess:(InstagramResponseBlock)success
           failure:(InstagramFailureBlock)failure;

- (void)unfollowUser:(NSString *)userId
         withSuccess:(InstagramResponseBlock)success
             failure:(InstagramFailureBlock)failure;

- (void)blockUser:(NSString *)userId
      withSuccess:(InstagramResponseBlock)success
          failure:(InstagramFailureBlock)failure;

- (void)unblockUser:(NSString *)userId
        withSuccess:(InstagramResponseBlock)success
            failure:(InstagramFailureBlock)failure;

- (void)approveUser:(NSString *)userId
        withSuccess:(InstagramResponseBlock)success
            failure:(InstagramFailureBlock)failure;

- (void)denyUser:(NSString *)userId
     withSuccess:(InstagramResponseBlock)success
         failure:(InstagramFailureBlock)failure;


#pragma mark - Common Pagination Request -

- (void)getPaginatedItemsForInfo:(InstagramPaginationInfo *)paginationInfo
                     withSuccess:(InstagramObjectsBlock)success
                         failure:(InstagramFailureBlock)failure;

@end
