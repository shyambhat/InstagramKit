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

