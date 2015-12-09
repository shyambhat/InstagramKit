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


NS_ASSUME_NONNULL_BEGIN


@interface InstagramEngine : NSObject

/*!
 @abstract Gets the singleton instance.
 */
+ (instancetype)sharedEngine;

/**
 *  Client Id of your App, as registered with Instagram.
 */
@property (nonatomic, copy, readonly) NSString *appClientID;

/**
 *  Redirect URL of your App, as registered with Instagram.
 */
@property (nonatomic, copy, readonly) NSString *appRedirectURL;

/**
 *  The oauth token stored in the account store credential, if available.
 *  If not empty, this implies user has granted access.
 */
@property (nonatomic, copy, nullable) NSString *accessToken;


#pragma mark - Authentication -


/**
 *  A convenience method to generate an authorization URL with Basic permissions
 *  to direct user to Instagram's login screen.
 *
 *  @return URL to direct user to Instagram's login screen.
 */
- (NSURL *)authorizationURL;


/**
 *  A convenience method to generate an authorization URL to direct user to Instagram's login screen.
 *
 *  @param scope Scope based on permissions required.
 *
 *  @return URL to direct user to Instagram's login screen.
 */
- (NSURL *)authorizationURLForScope:(InstagramKitLoginScope)scope;


/**
 *  A convenience method to extract and save the access code from an URL received in
 *  UIWebView's delegate method - webView: shouldStartLoadWithRequest: navigationType:
 *  @param url   URL from the request object.
 *  @param error Error in extracting token, if any.
 *
 *  @return YES if valid token extracted and saved, otherwise NO.
 */
- (BOOL)receivedValidAccessTokenFromURL:(NSURL *)url
                                  error:(NSError * _Nullable __autoreleasing *)error;

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

/**
 *  Get information about a Media object.
 *
 *  @param mediaId  Id of a Media object.
 *  @param success  Provides a fully populated Media object.
 *  @param failure  Provides an error and a server status code.
 */
- (void)getMedia:(NSString *)mediaId
     withSuccess:(InstagramMediaObjectBlock)success
         failure:(nullable InstagramFailureBlock)failure;


/**
 *  Get a list of currently popular media.
 *
 *  @param success  Provides an array of Media objects and Pagination info.
 *  @param failure  Provides an error and a server status code.
 */
- (void)getPopularMediaWithSuccess:(InstagramMediaBlock)success
                           failure:(nullable InstagramFailureBlock)failure;


#pragma mark -


/**
 *  Search for media in a given area. The default time span is set to 5 days. 
 *  Can return mix of image and video types.
 *
 *  @param location Geographic Location coordinates.
 *  @param success  Provides an array of Media objects and Pagination info.
 *  @param failure  Provides an error and a server status code.
 */
- (void)getMediaAtLocation:(CLLocationCoordinate2D)location
               withSuccess:(InstagramMediaBlock)success
                   failure:(nullable InstagramFailureBlock)failure;

/**
 *  Search for media in a given area. The default time span is set to 5 days.
 *  Can return mix of image and video types.
 *
 *  @param location Geographic Location coordinates.
 *  @param count    Count of objects to fetch.
 *  @param maxId    The nextMaxId from the previously obtained PaginationInfo object.
 *  @param distance Distance in metres to from location - max 5000 (5km), default is 1000 (1km) in other methods
 *  @param success  Provides an array of Media objects and Pagination info.
 *  @param failure  Provides an error and a server status code.
 */
- (void)getMediaAtLocation:(CLLocationCoordinate2D)location
                     count:(NSInteger)count
                     maxId:(nullable NSString *)maxId
                  distance:(CGFloat)distance
               withSuccess:(InstagramMediaBlock)success
                   failure:(nullable InstagramFailureBlock)failure;

/**
 *  Get a list of recent media objects from a given location.
 *
 *  @param locationId   Id of a Location object.
 *  @param success      Provides an array of Media objects and Pagination info.
 *  @param failure      Provides an error and a server status code.
 */
- (void)getMediaAtLocationWithId:(NSString*)locationId
                     withSuccess:(InstagramMediaBlock)success
                         failure:(nullable InstagramFailureBlock)failure;


#pragma mark - Locations -


/**
 *  Search for a location by geographic coordinate.
 *
 *  @param location Geographic Location coordinates.
 *  @param success  Provides an array of Location objects.
 *  @param failure  Provides an error and a server status code.
 */
- (void)searchLocationsAtLocation:(CLLocationCoordinate2D)loction
                      withSuccess:(InstagramLocationsBlock)success
                          failure:(nullable InstagramFailureBlock)failure;


/**
 *  Search for a location by geographic coordinate.
 *
 *  @param location         Geographic Location coordinates.
 *  @param distanceInMeters Default is 1000, max distance is 5000.
 *  @param success          Provides an array of Location objects.
 *  @param failure          Provides an error and a server status code.
 */
- (void)searchLocationsAtLocation:(CLLocationCoordinate2D)loction
                 distanceInMeters:(NSInteger)distance
                      withSuccess:(InstagramLocationsBlock)success
                          failure:(nullable InstagramFailureBlock)failure;


/**
 *  Get information about a Location.
 *
 *  @param locationId   Id of a Location object.
 *  @param success      Provides a Location object.
 *  @param failure      Provides an error and a server status code.
 */
- (void)getLocationWithId:(NSString*)locationId
              withSuccess:(InstagramLocationBlock)success
                  failure:(nullable InstagramFailureBlock)failure;


#pragma mark - Users -


/**
 *  Get basic information about a user.
 *
 *  @param userId   Id of a User object.
 *  @param success  Provides a fully populated User object.
 *  @param failure  Provides an error and a server status code.
 */
- (void)getUserDetails:(NSString *)userId
           withSuccess:(InstagramUserBlock)success
               failure:(nullable InstagramFailureBlock)failure;


#pragma mark -


/**
 *  Get the most recent media published by a user.
 *
 *  @param userId   Id of a User object.
 *  @param success  Provides an array of Media objects and Pagination info.
 *  @param failure  Provides an error and a server status code.
 */
- (void)getMediaForUser:(NSString *)userId
            withSuccess:(InstagramMediaBlock)success
                failure:(nullable InstagramFailureBlock)failure;


/**
 *  Get the most recent media published by a user.
 *
 *  @param userId   Id of a User object.
 *  @param count    Count of objects to fetch.
 *  @param maxId    The nextMaxId from the previously obtained PaginationInfo object.
 *  @param success  Provides an array of Media objects and Pagination info.
 *  @param failure  Provides an error and a server status code.
 */
- (void)getMediaForUser:(NSString *)userId
                  count:(NSInteger)count
                  maxId:(nullable NSString *)maxId
            withSuccess:(InstagramMediaBlock)success
                failure:(nullable InstagramFailureBlock)failure;


#pragma mark -


/**
 *  Search for a user by name.
 *
 *  @param name     Name string as search query.
 *  @param success  Provides an array of User objects and Pagination info.
 *  @param failure  Provides an error and a server status code.
 */
- (void)searchUsersWithString:(NSString *)name
                  withSuccess:(InstagramUsersBlock)success
                      failure:(nullable InstagramFailureBlock)failure;


#pragma mark - Self User -


/**
 *  Get basic information about the authenticated user.
 *
 *  @param success  Provides an User object.
 *  @param failure  Provides an error and a server status code.
 */
- (void)getSelfUserDetailsWithSuccess:(InstagramUserBlock)success
                              failure:(nullable InstagramFailureBlock)failure;


#pragma mark -


/**
 *  Get the authenticated user's feed.
 *
 *  @param success  Provides an array of Media objects and Pagination info.
 *  @param failure  Provides an error and a server status code.
 */
- (void)getSelfFeedWithSuccess:(InstagramMediaBlock)success
                       failure:(nullable InstagramFailureBlock)failure;


/**
 *  Get the authenticated user's feed.
 *
 *  @param count    Count of objects to fetch.
 *  @param maxId    The nextMaxId from the previously obtained PaginationInfo object.
 *  @param success  Provides an array of Media objects and Pagination info.
 *  @param failure  Provides an error and a server status code.
 */
- (void)getSelfFeedWithCount:(NSInteger)count
                       maxId:(nullable NSString *)maxId
                     success:(InstagramMediaBlock)success
                     failure:(nullable InstagramFailureBlock)failure;


#pragma mark -


/**
 *  See the list of media liked by the authenticated user. 
 *  Private media is returned as long as the authenticated user has permission to view that media.
 *  Liked media lists are only available for the currently authenticated user.
 *
 *  @param success  Provides an array of Media objects and Pagination info.
 *  @param failure  Provides an error and a server status code.
 */
- (void)getMediaLikedBySelfWithSuccess:(InstagramMediaBlock)success
                               failure:(nullable InstagramFailureBlock)failure;


/**
 *  See the list of media liked by the authenticated user.
 *  Private media is returned as long as the authenticated user has permission to view that media.
 *  Liked media lists are only available for the currently authenticated user.
 *
 *  @param count    Count of objects to fetch.
 *  @param maxId    The nextMaxId from the previously obtained PaginationInfo object.
 *  @param success  Provides an array of Media objects and Pagination info.
 *  @param failure  Provides an error and a server status code.
 */
- (void)getMediaLikedBySelfWithCount:(NSInteger)count
                               maxId:(nullable NSString *)maxId
                             success:(InstagramMediaBlock)success
                             failure:(nullable InstagramFailureBlock)failure;


#pragma mark -


/**
 *  Get the most recent media published by the authenticated user.
 *
 *  @param success  Provides an array of Media objects and Pagination info.
 *  @param failure  Provides an error and a server status code.
 */
- (void)getSelfRecentMediaWithSuccess:(InstagramMediaBlock)success
                              failure:(nullable InstagramFailureBlock)failure;


/**
 *  Get the most recent media published by the authenticated user.
 *
 *  @param count    Count of objects to fetch.
 *  @param maxId    The nextMaxId from the previously obtained PaginationInfo object.
 *  @param success  Provides an array of Media objects and Pagination info.
 *  @param failure  Provides an error and a server status code.
 */
- (void)getSelfRecentMediaWithCount:(NSInteger)count
                              maxId:(nullable NSString *)maxId
                            success:(InstagramMediaBlock)success
                            failure:(nullable InstagramFailureBlock)failure;


#pragma mark - Tags -


/**
 *  Get information about a tag object.
 *
 *  @param name     Name of a Tag object.
 *  @param success  Provides a Tag object.
 *  @param failure  Provides an error and a server status code.
 */
- (void)getTagDetailsWithName:(NSString *)name
                  withSuccess:(InstagramTagBlock)success
                      failure:(nullable InstagramFailureBlock)failure;


#pragma mark -


/**
 *  Get a list of recently tagged media.
 *
 *  @param tag      Name of a Tag object.
 *  @param success  Provides an array of Media objects and Pagination info.
 *  @param failure  Provides an error and a server status code.
 */
- (void)getMediaWithTagName:(NSString *)name
                withSuccess:(InstagramMediaBlock)success
                    failure:(nullable InstagramFailureBlock)failure;


/**
 *  Get a list of recently tagged media.
 *
 *  @param tag      Name of a Tag object.
 *  @param count    Count of objects to fetch.
 *  @param maxId    The nextMaxId from the previously obtained PaginationInfo object.
 *  @param success  Provides an array of Media objects and Pagination info.
 *  @param failure  Provides an error and a server status code.
 */
- (void)getMediaWithTagName:(NSString *)tag
                      count:(NSInteger)count
                      maxId:(nullable NSString *)maxId
                withSuccess:(InstagramMediaBlock)success
                    failure:(nullable InstagramFailureBlock)failure;


#pragma mark -


/**
 *  Search for tags by name.
 *
 *  @param name     A valid tag name without a leading #. (eg. snowy, nofilter)
 *  @param success  Provides an array of Tag objects and Pagination info.
 *  @param failure  Provides an error and a server status code.
 */
- (void)searchTagsWithName:(NSString *)name
               withSuccess:(InstagramTagsBlock)success
                   failure:(nullable InstagramFailureBlock)failure;


/**
 *  Search for tags by name.
 *
 *  @param name     A valid tag name without a leading #. (eg. snowy, nofilter)
 *  @param count    Count of objects to fetch.
 *  @param maxId    The nextMaxId from the previously obtained PaginationInfo object.
 *  @param success  Provides an array of Tag objects and Pagination info.
 *  @param failure  Provides an error and a server status code.
 */
- (void)searchTagsWithName:(NSString *)name
                     count:(NSInteger)count
                     maxId:(nullable NSString *)maxId
               withSuccess:(InstagramTagsBlock)success
                   failure:(nullable InstagramFailureBlock)failure;


#pragma mark - Comments -


/**
 *  Get a list of recent comments on a media object.
 *
 *  @param mediaId  Id of the Media object.
 *  @param success  Provides an array of Comment objects.
 *  @param failure  Provides an error and a server status code.
 */
- (void)getCommentsOnMedia:(NSString *)mediaId
               withSuccess:(InstagramCommentsBlock)success
                   failure:(nullable InstagramFailureBlock)failure;


/**
 *  Create a comment on a media object with the following rules:
 *  - The total length of the comment cannot exceed 300 characters.
 *  - The comment cannot contain more than 4 hashtags.
 *  - The comment cannot contain more than 1 URL.
 *  - The comment cannot consist of all capital letters.
 *
 *  REQUIREMENTS : InstagramKitLoginScopeComments during authentication.
 *
 *  To request access to this endpoint, please complete this form -
 *  https://help.instagram.com/contact/185819881608116
 *
 *  @param commentText  The comment text.
 *  @param mediaId      Id of the Media object.
 *  @param success      Invoked on successfully creating comment.
 *  @param failure      Provides an error and a server status code.
 */
- (void)createComment:(NSString *)commentText
              onMedia:(NSString *)mediaId
          withSuccess:(InstagramResponseBlock)success
              failure:(nullable InstagramFailureBlock)failure;


/**
 *  Remove a comment either on the authenticated user's media object 
 *  or authored by the authenticated user.
 *
 *  REQUIREMENTS : InstagramKitLoginScopeComments during authentication.
 *
 *  To request access to this endpoint, please complete this form -
 *  https://help.instagram.com/contact/185819881608116
 *
 *  @param commentId    Id of the Comment object.
 *  @param mediaId      Id of the Media object.
 *  @param success      Invoked on successfully deleting comment.
 *  @param failure      Provides an error and a server status code.
 */
- (void)removeComment:(NSString *)commentId
              onMedia:(NSString *)mediaId
          withSuccess:(InstagramResponseBlock)success
              failure:(nullable InstagramFailureBlock)failure;


#pragma mark - Likes -


/**
 *  Get a list of users who have liked this media.
 *
 *  @param mediaId  Id of the Media object.
 *  @param success  Provides an array of User objects.
 *  @param failure  Provides an error and a server status code.
 */
- (void)getLikesOnMedia:(NSString *)mediaId
            withSuccess:(InstagramUsersBlock)success
                failure:(nullable InstagramFailureBlock)failure;


/**
 *  Set a like on this media by the currently authenticated user.
 *  REQUIREMENTS : InstagramKitLoginScopeLikes during authentication.
 *
 *  To request access to this endpoint, please complete this form -
 *  https://help.instagram.com/contact/185819881608116
 *
 *  @param mediaId  Id of the Media object.
 *  @param success  Invoked on successfully liking a Media.
 *  @param failure  Provides an error and a server status code.
 */
- (void)likeMedia:(NSString *)mediaId
      withSuccess:(InstagramResponseBlock)success
          failure:(nullable InstagramFailureBlock)failure;


/**
 *  Remove a like on this media by the currently authenticated user.
 *  REQUIREMENTS : InstagramKitLoginScopeLikes during authentication.
 *
 *  To request access to this endpoint, please complete this form -
 *  https://help.instagram.com/contact/185819881608116
 *
 *  @param mediaId  Id of the Media object.
 *  @param success  Invoked on successfully un-liking a Media.
 *  @param failure  Provides an error and a server status code.
 */
- (void)unlikeMedia:(NSString *)mediaId
        withSuccess:(InstagramResponseBlock)success
            failure:(nullable InstagramFailureBlock)failure;


#pragma mark - Relationships -


/**
 *  Get information about a relationship to another user.
 *
 *  @param userId   Id of the User object.
 *  @param success  Provides the server response as is.
 *  @param failure  Provides an error and a server status code.
 */
- (void)getRelationshipStatusOfUser:(NSString *)userId
                        withSuccess:(InstagramResponseBlock)success
                            failure:(nullable InstagramFailureBlock)failure;


/**
 *  Get the list of users this user follows.
 *
 *  @param userId   Id of the User object.
 *  @param success  Provides an array of User objects and Pagination info.
 *  @param failure  Provides an error and a server status code.
 */
- (void)getUsersFollowedByUser:(NSString *)userId
                   withSuccess:(InstagramUsersBlock)success
                       failure:(nullable InstagramFailureBlock)failure;


/**
 *  Get the list of users this user is followed by.
 *
 *  @param userId   Id of the User object.
 *  @param success  Provides an array of User objects and Pagination info.
 *  @param failure  Provides an error and a server status code.
 */
- (void)getFollowersOfUser:(NSString *)userId
               withSuccess:(InstagramUsersBlock)success
                   failure:(nullable InstagramFailureBlock)failure;


/**
 *  List the users who have requested this user's permission to follow.
 *
 *  @param success  Provides an array of User objects and Pagination info.
 *  @param failure  Provides an error and a server status code.
 */
- (void)getFollowRequestsWithSuccess:(InstagramUsersBlock)success
                             failure:(nullable InstagramFailureBlock)failure;


/**
 *  Modify the relationship between the current user and the target user.
 *  Follow a user.
 *
 *  REQUIREMENTS : InstagramKitLoginScopeRelationships during authentication.
 *
 *  To request access to this endpoint, please complete this form -
 *  https://help.instagram.com/contact/185819881608116
 *
 *  @param userId   Id of the User object.
 *  @param success  Provides the server response as is.
 *  @param failure  Provides an error and a server status code.
 */
- (void)followUser:(NSString *)userId
       withSuccess:(InstagramResponseBlock)success
           failure:(nullable InstagramFailureBlock)failure;


/**
 *  Modify the relationship between the current user and the target user.
 *  Unfollow a user.
 *
 *  REQUIREMENTS : InstagramKitLoginScopeRelationships during authentication.
 *
 *  To request access to this endpoint, please complete this form -
 *  https://help.instagram.com/contact/185819881608116
 *
 *  @param userId   Id of the User object.
 *  @param success  Provides the server response as is.
 *  @param failure  Provides an error and a server status code.
 */
- (void)unfollowUser:(NSString *)userId
         withSuccess:(InstagramResponseBlock)success
             failure:(nullable InstagramFailureBlock)failure;


/**
 *  Modify the relationship between the current user and the target user.
 *  Block a user.
 *
 *  REQUIREMENTS : InstagramKitLoginScopeRelationships during authentication.
 *
 *  To request access to this endpoint, please complete this form -
 *  https://help.instagram.com/contact/185819881608116
 *
 *  @param userId   Id of the User object.
 *  @param success  Provides the server response as is.
 *  @param failure  Provides an error and a server status code.
 */
- (void)blockUser:(NSString *)userId
      withSuccess:(InstagramResponseBlock)success
          failure:(nullable InstagramFailureBlock)failure;


/**
 *  Modify the relationship between the current user and the target user.
 *  Unblock a user.
 *
 *  REQUIREMENTS : InstagramKitLoginScopeRelationships during authentication.
 *
 *  To request access to this endpoint, please complete this form -
 *  https://help.instagram.com/contact/185819881608116
 *
 *  @param userId   Id of the User object.
 *  @param success  Provides the server response as is.
 *  @param failure  Provides an error and a server status code.
 */
- (void)unblockUser:(NSString *)userId
        withSuccess:(InstagramResponseBlock)success
            failure:(nullable InstagramFailureBlock)failure;


/**
 *  Modify the relationship between the current user and the target user.
 *  Approve a user.
 *
 *  REQUIREMENTS : InstagramKitLoginScopeRelationships during authentication.
 *
 *  To request access to this endpoint, please complete this form -
 *  https://help.instagram.com/contact/185819881608116
 *
 *  @param userId   Id of the User object.
 *  @param success  Provides the server response as is.
 *  @param failure  Provides an error and a server status code.
 */
- (void)approveUser:(NSString *)userId
        withSuccess:(InstagramResponseBlock)success
            failure:(nullable InstagramFailureBlock)failure;


/**
 *  Modify the relationship between the current user and the target user.
 *  Ignore a user.
 *
 *  REQUIREMENTS : InstagramKitLoginScopeRelationships during authentication.
 *
 *  To request access to this endpoint, please complete this form -
 *  https://help.instagram.com/contact/185819881608116
 *
 *  @param userId   Id of the User object.
 *  @param success  Provides the server response as is.
 *  @param failure  Provides an error and a server status code.
 */
- (void)ignoreUser:(NSString *)userId
     withSuccess:(InstagramResponseBlock)success
         failure:(nullable InstagramFailureBlock)failure;


#pragma mark - Common Pagination Request -


/**
 *  Get paginated objects as specified by information contained in the PaginationInfo object.
 *
 *  @param paginationInfo The PaginationInfo Object obtained from the previous endpoint success block.
 *  @param success        Provides an array of paginated Objects.
 *  @param failure        Provides an error and a server status code.
 */
- (void)getPaginatedItemsForInfo:(InstagramPaginationInfo *)paginationInfo
                     withSuccess:(InstagramPaginatiedResponseBlock)success
                         failure:(nullable InstagramFailureBlock)failure;


@end

NS_ASSUME_NONNULL_END
