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

#import "InstagramModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface InstagramUser : InstagramModel <NSCopying, NSSecureCoding, NSObject>

/**
 *  User's unique username.
 */
@property (nonatomic, copy, readonly) NSString *username;

/**
 *  User's full name.
 */
@property (nonatomic, copy, readonly, nullable) NSString *fullName;

/**
 *  Link to the User's profile picture.
 */
@property (nonatomic, readonly, nullable) NSURL *profilePictureURL;

/**
 *  User's short bio, if provided.
 */
@property (nonatomic, copy, readonly, nullable) NSString *bio;

/**
 *  User's website, if provided.
 */
@property (nonatomic, readonly, nullable) NSURL *website;

/**
 *  Number of Media uploaded by the User.
 *  This value is not persisted while saving the state of the User object.
 */
@property (nonatomic, readonly) NSInteger mediaCount;

/**
 *  Number of Instagram Users, this User follows.
 *  This value is not persisted while saving the state of the User object.
 */
@property (nonatomic, readonly) NSInteger followsCount;

/**
 *  Followers count of this User.
 *  This value is not persisted while saving the state of the User object.
 */
@property (nonatomic, readonly) NSInteger followedByCount;

/**
 *  Convenience method to load details and update object.
 *  @param info JSON dictionary
 */
- (void)loadDetailsWithCompletion:(void (^)(void))success
                          failure:(nullable InstagramFailureBlock)failure;


/**
 *  Comparing InstagramUser objects.
 *  @param user An InstagramUser object.
 *  @return     YES is Ids match. Else NO.
 */
- (BOOL)isEqualToUser:(InstagramUser *)user;

@end

NS_ASSUME_NONNULL_END
