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

@interface IKCommentEndpoints : IKEndpointsBase


/**
 *  Get a list of recent comments on a media object.
 *
 *  @param mediaId  Id of the Media object.
 *  @param success  Provides an array of Comment objects.
 *  @param failure  Provides an error and a server status code.
 */
- (void)getCommentsOnMedia:(NSString *)mediaId
               withSuccess:(IKCommentsBlock)success
                   failure:(nullable InstagramFailureBlock)failure;


/**
 *  Create a comment on a media object with the following rules:
 *  - The total length of the comment cannot exceed 300 characters.
 *  - The comment cannot contain more than 4 hashtags.
 *  - The comment cannot contain more than 1 URL.
 *  - The comment cannot consist of all capital letters.
 *
 *  REQUIREMENTS : IKLoginScopeComments during authentication.
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
 *  REQUIREMENTS : IKLoginScopeComments during authentication.
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

