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
           withSuccess:(IKUserBlock)success
               failure:(nullable InstagramFailureBlock)failure;


/**
 *  Get the most recent media published by a user.
 *
 *  @param userId   Id of a User object.
 *  @param success  Provides an array of Media objects and Pagination info.
 *  @param failure  Provides an error and a server status code.
 */
- (void)getMediaForUser:(NSString *)userId
            withSuccess:(IKMediaBlock)success
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
            withSuccess:(IKMediaBlock)success
                failure:(nullable InstagramFailureBlock)failure;


/**
 *  Search for a user by name.
 *
 *  @param name     Name string as search query.
 *  @param success  Provides an array of User objects and Pagination info.
 *  @param failure  Provides an error and a server status code.
 */
- (void)searchUsersWithString:(NSString *)name
                  withSuccess:(IKUsersBlock)success
                      failure:(nullable InstagramFailureBlock)failure;


@end

NS_ASSUME_NONNULL_END
