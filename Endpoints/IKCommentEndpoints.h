//
//  IKCommentsEndpoints.h
//  InstagramKit
//
//  Created by Shyam Bhat on 6/4/18.
//

#import "IKEndpointsBase.h"

NS_ASSUME_NONNULL_BEGIN

@interface IKCommentEndpoints : IKEndpointsBase


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


@end

NS_ASSUME_NONNULL_END

