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
#import "InstagramKitConstants.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  JSON keys as string constants.
 */
INSTAGRAMKIT_EXTERN NSString *const kID;
INSTAGRAMKIT_EXTERN NSString *const kCount;
INSTAGRAMKIT_EXTERN NSString *const kURL;
INSTAGRAMKIT_EXTERN NSString *const kHeight;
INSTAGRAMKIT_EXTERN NSString *const kWidth;
INSTAGRAMKIT_EXTERN NSString *const kData;

INSTAGRAMKIT_EXTERN NSString *const kThumbnail;
INSTAGRAMKIT_EXTERN NSString *const kLowResolution;
INSTAGRAMKIT_EXTERN NSString *const kStandardResolution;

INSTAGRAMKIT_EXTERN NSString *const kMediaTypeImage;
INSTAGRAMKIT_EXTERN NSString *const kMediaTypeVideo;

INSTAGRAMKIT_EXTERN NSString *const kUser;
INSTAGRAMKIT_EXTERN NSString *const kUserHasLiked;
INSTAGRAMKIT_EXTERN NSString *const kCreatedDate;
INSTAGRAMKIT_EXTERN NSString *const kLink;
INSTAGRAMKIT_EXTERN NSString *const kCaption;
INSTAGRAMKIT_EXTERN NSString *const kLikes;
INSTAGRAMKIT_EXTERN NSString *const kComments;
INSTAGRAMKIT_EXTERN NSString *const kFilter;
INSTAGRAMKIT_EXTERN NSString *const kTags;
INSTAGRAMKIT_EXTERN NSString *const kImages;
INSTAGRAMKIT_EXTERN NSString *const kVideos;
INSTAGRAMKIT_EXTERN NSString *const kLocation;
INSTAGRAMKIT_EXTERN NSString *const kType;

INSTAGRAMKIT_EXTERN NSString *const kCreator;
INSTAGRAMKIT_EXTERN NSString *const kText;

INSTAGRAMKIT_EXTERN NSString *const kUsername;
INSTAGRAMKIT_EXTERN NSString *const kFullName;
INSTAGRAMKIT_EXTERN NSString *const kFirstName;
INSTAGRAMKIT_EXTERN NSString *const kLastName;
INSTAGRAMKIT_EXTERN NSString *const kProfilePictureURL;
INSTAGRAMKIT_EXTERN NSString *const kBio;
INSTAGRAMKIT_EXTERN NSString *const kWebsite;

INSTAGRAMKIT_EXTERN NSString *const kCounts;
INSTAGRAMKIT_EXTERN NSString *const kCountMedia;
INSTAGRAMKIT_EXTERN NSString *const kCountFollows;
INSTAGRAMKIT_EXTERN NSString *const kCountFollowedBy;

INSTAGRAMKIT_EXTERN NSString *const kUsersInPhoto;
INSTAGRAMKIT_EXTERN NSString *const kPosition;
INSTAGRAMKIT_EXTERN NSString *const kX;
INSTAGRAMKIT_EXTERN NSString *const kY;

INSTAGRAMKIT_EXTERN NSString *const kTagMediaCount;
INSTAGRAMKIT_EXTERN NSString *const kTagName;

INSTAGRAMKIT_EXTERN NSString *const kLocationLatitude;
INSTAGRAMKIT_EXTERN NSString *const kLocationLongitude;
INSTAGRAMKIT_EXTERN NSString *const kLocationName;

@interface InstagramModel : NSObject <NSCopying, NSSecureCoding, NSObject>

/**
 *  The unique identifier for each model object.
 */
@property (atomic, readonly, copy) NSString *Id;

/**
 *  Initializes a new instance.
 *  @param info JSON dictionary
 */
- (instancetype)initWithInfo:(NSDictionary *)info;

/**
 *  Comparing Instagram model objects.
 *  @param model A model object.
 *  @return YES is Ids match. Else NO.
 */
- (BOOL)isEqualToModel:(InstagramModel *)model;

@end

NS_ASSUME_NONNULL_END
