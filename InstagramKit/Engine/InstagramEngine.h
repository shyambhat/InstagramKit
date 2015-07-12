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

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import "InstagramKitConstants.h"

@interface InstagramEngine : NSObject

/*!
 @abstract Gets the singleton instance.
 */
+ (instancetype)sharedEngine;

/**
 *  Client Id of your App, as registered with Instagram.
 */
@property (nonatomic, copy) NSString *appClientID;

/**
 *  Redirect URL of your App, as registered with Instagram.
 */
@property (nonatomic, copy) NSString *appRedirectURL;

/**
 *  The oauth token stored in the account store credential, if available.
 *  If not empty, this implies user has granted access.
 */
@property (nonatomic, strong) NSString *accessToken;


#pragma mark - Authentication -

/**
 *  A convenience method to generate an authentication URL to direct user to Instagram's login screen.
 *
 *  @param scope Scope based on permissions required.
 *
 *  @return URL to direct user to Instagram's login screen.
 */
- (NSURL *)authorizarionURLForScope:(InstagramKitLoginScope)scope;


/**
 *  A convenience method to extract and save the access code from an URL received in
 *  UIWebView's delegate method - webView: shouldStartLoadWithRequest: navigationType:
 *  @param url   URL from the request object.
 *  @param error Error in extracting token, if any.
 *
 *  @return YES if valid token extracted and saved, otherwise NO.
 */
- (BOOL)extractValidAccessTokenFromURL:(NSURL *)url
                                 error:(NSError *__autoreleasing *)error;

/**
 *  Validate if authorization is done.
 *
 *  @return YES if access token present, otherwise NO.
 */
- (BOOL)isSessionValid;

/**
 *  Clears stored access token and browser cookies.
 */
- (void)logout;


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


#pragma mark - Locations -


- (void)searchLocationsAtLocation:(CLLocationCoordinate2D)loction
                      withSuccess:(InstagramLocationsBlock)success
                          failure:(InstagramFailureBlock)failure;


- (void)searchLocationsAtLocation:(CLLocationCoordinate2D)loction
                 distanceInMeters:(NSInteger)distance
                      withSuccess:(InstagramLocationsBlock)success
                          failure:(InstagramFailureBlock)failure;


- (void)getLocationWithId:(NSString*)locationId
              withSuccess:(InstagramLocationBlock)success
                  failure:(InstagramFailureBlock)failure;


- (void)getMediaAtLocationWithId:(NSString*)locationId
                     withSuccess:(InstagramMediaBlock)success
                         failure:(InstagramFailureBlock)failure;


#pragma mark - Users -


- (void)getUserDetails:(InstagramUser *)user
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
