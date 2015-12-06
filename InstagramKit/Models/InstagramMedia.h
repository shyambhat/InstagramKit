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
#import <CoreLocation/CoreLocation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "InstagramModel.h"

@class InstagramUser;
@class InstagramComment;
@class UserInPhoto;
@class InstagramLocation;

NS_ASSUME_NONNULL_BEGIN

@interface InstagramMedia : InstagramModel <NSCopying, NSSecureCoding, NSObject>

/**
 *  Creator of the Media.
 */
@property (nonatomic, readonly) InstagramUser *user;

/**
 *  Is Media liked by the authenticated user.
 */
@property (nonatomic, readonly) BOOL userHasLiked;

/**
 *  Date of creation of Media.
 */
@property (nonatomic, readonly) NSDate *createdDate;

/**
 *  Web Link to the Media.
 */
@property (nonatomic, readonly, copy) NSString *link;

/**
 *  Caption created by creator of the Media.
 */
@property (nonatomic, readonly, nullable) InstagramComment *caption;

/**
 *  Number of likes on the Media.
 */
@property (nonatomic, readonly) NSInteger likesCount;

/**
 *  List of users who have liked the Media.
 */
@property (nonatomic, readonly, nullable) NSArray <InstagramUser *> *likes;

/**
 *  Number of comments on the Media.
 */
@property (nonatomic, readonly) NSInteger commentCount;

/**
 *  An array of comments on the Media.
 */
@property (nonatomic, readonly, nullable) NSArray <InstagramComment *> *comments;

/**
 *  An array of users in the Media.
 */
@property (nonatomic, readonly, nullable) NSArray <UserInPhoto *> *usersInPhoto;

/**
 *  Tags on the Media.
 */
@property (nonatomic, readonly, nullable) NSArray <InstagramTag *> *tags;

/**
 *  Media Location coordinates
 */
@property (nonatomic, readonly) CLLocationCoordinate2D location;

/**
 *  Media Location id.
 */
@property (nonatomic, readonly, copy, nullable) NSString *locationId;

/**
 *  Media Location name.
 */
@property (nonatomic, readonly, copy, nullable) NSString *locationName;

/**
 *  Filter applied on Media during creation.
 */
@property (nonatomic, readonly, copy, nullable) NSString *filter;

/**
 *  Link to the thumbnail image of the Media.
 */
@property (nonatomic, readonly) NSURL *thumbnailURL;

/**
 *  Size of the thumbnail image frame.
 */
@property (nonatomic, readonly) CGSize thumbnailFrameSize;

/**
 *  Link to the low resolution image of the Media.
 */
@property (nonatomic, readonly) NSURL *lowResolutionImageURL;

/**
 *  Size of the low resolution image frame.
 */
@property (nonatomic, readonly) CGSize lowResolutionImageFrameSize;

/**
 *  Link to the standard resolution image of the Media.
 */
@property (nonatomic, readonly) NSURL *standardResolutionImageURL;

/**
 *  Size of the standard resolution image frame.
 */
@property (nonatomic, readonly) CGSize standardResolutionImageFrameSize;

/**
 *  Indicates if Media is a video.
 */
@property (nonatomic, readonly) BOOL isVideo;

/**
 *  Link to the low resolution video of the Media, if Media is a video.
 */
@property (nonatomic, readonly, nullable) NSURL *lowResolutionVideoURL;

/**
 *  Size of the low resolution video frame.
 */
@property (nonatomic, readonly) CGSize lowResolutionVideoFrameSize;

/**
 *  Link to the standard resolution video of the Media, if Media is a video.
 */
@property (nonatomic, readonly, nullable) NSURL *standardResolutionVideoURL;

/**
 *  Size of the standard resolution video frame.
 */
@property (nonatomic, readonly) CGSize standardResolutionVideoFrameSize;

/**
 *  Comparing InstagramMedia objects.
 *  @param media    An InstagramMedia object.
 *  @return         YES is Ids match. Else NO.
 */
- (BOOL)isEqualToMedia:(InstagramMedia *)media;

@end

NS_ASSUME_NONNULL_END
