//
//  IKLikeEndpoints.h
//  InstagramKit
//
//  Created by Shyam Bhat on 6/4/18.
//

#import "IKEndpointsBase.h"

NS_ASSUME_NONNULL_BEGIN

@interface IKLikeEndpoints : IKEndpointsBase


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


@end

NS_ASSUME_NONNULL_END

