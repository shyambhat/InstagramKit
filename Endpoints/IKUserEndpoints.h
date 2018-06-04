//
//  IKUserEndpoints.h
//  InstagramKit
//
//  Created by Shyam Bhat on 6/4/18.
//

#import "IKEndpointsBase.h"

NS_ASSUME_NONNULL_BEGIN

@interface IKUserEndpoints : IKEndpointsBase


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


@end

NS_ASSUME_NONNULL_END
