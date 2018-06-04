//
//  IKSelfEndpoints.h
//  InstagramKit
//
//  Created by Shyam Bhat on 6/4/18.
//

#import "IKEndpointsBase.h"

NS_ASSUME_NONNULL_BEGIN

@interface IKSelfEndpoints : IKEndpointsBase


/**
 *  Get basic information about the authenticated user.
 *
 *  @param success  Provides an User object.
 *  @param failure  Provides an error and a server status code.
 */
- (void)getSelfUserDetailsWithSuccess:(InstagramUserBlock)success
                              failure:(nullable InstagramFailureBlock)failure;


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


/**
 *  Get the list of users the logged in user follows.
 *
 *  @param success  Provides an array of User objects and Pagination info.
 *  @param failure  Provides an error and a server status code.
 */
- (void)getUsersFollowedBySelfWithSuccess:(InstagramUsersBlock)success
                                  failure:(nullable InstagramFailureBlock)failure;


/**
 *  Get the list of users the logged in user is followed by.
 *
 *  @param success  Provides an array of User objects and Pagination info.
 *  @param failure  Provides an error and a server status code.
 */
- (void)getFollowersOfSelfWithSuccess:(InstagramUsersBlock)success
                              failure:(nullable InstagramFailureBlock)failure;


@end

NS_ASSUME_NONNULL_END

