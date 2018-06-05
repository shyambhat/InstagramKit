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

@interface IKRelationshipEndpoints : IKEndpointsBase


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
 *  List the users who have requested this user's permission to follow.
 *
 *  @param success  Provides an array of User objects and Pagination info.
 *  @param failure  Provides an error and a server status code.
 */
- (void)getFollowRequestsWithSuccess:(IKUsersBlock)success
                             failure:(nullable InstagramFailureBlock)failure;


/**
 *  Modify the relationship between the current user and the target user.
 *  Follow a user.
 *
 *  REQUIREMENTS : IKLoginScopeRelationships during authentication.
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
 *  REQUIREMENTS : IKLoginScopeRelationships during authentication.
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
 *  REQUIREMENTS : IKLoginScopeRelationships during authentication.
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
 *  REQUIREMENTS : IKLoginScopeRelationships during authentication.
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
 *  REQUIREMENTS : IKLoginScopeRelationships during authentication.
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
 *  REQUIREMENTS : IKLoginScopeRelationships during authentication.
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


@end

NS_ASSUME_NONNULL_END
