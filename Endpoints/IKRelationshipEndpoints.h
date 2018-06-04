//
//  IKRelationshipEndpoints.h
//  InstagramKit
//
//  Created by Shyam Bhat on 6/4/18.
//

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


@end

NS_ASSUME_NONNULL_END

