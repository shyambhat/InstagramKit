//
//    Copyright (c) 2013 Shyam Bhat
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

@interface InstagramModel : NSObject

@property (readonly) NSString* Id;

- (instancetype)initWithInfo:(NSDictionary *)info NS_DESIGNATED_INITIALIZER;

- (BOOL)isEqualToModel:(InstagramModel *)model;

@end


NSString *const kID;
NSString *const kCount;
NSString *const kURL;
NSString *const kHeight;
NSString *const kWidth;
NSString *const kData;
NSString *const kLatitude;
NSString *const kLongitude;
NSString *const kLocationName;

NSString *const kThumbnail;
NSString *const kLowResolution;
NSString *const kStandardResolution;

NSString *const kMediaTypeImage;
NSString *const kMediaTypeVideo;

NSString *const kUser;
NSString *const kUserHasLiked;
NSString *const kCreatedDate;
NSString *const kLink;
NSString *const kCaption;
NSString *const kLikes;
NSString *const kComments;
NSString *const kFilter;
NSString *const kTags;
NSString *const kImages;
NSString *const kVideos;
NSString *const kLocation;
NSString *const kType;

NSString *const kCreator;
NSString *const kText;

NSString *const kUsername;
NSString *const kFullName;
NSString *const kFirstName;
NSString *const kLastName;
NSString *const kProfilePictureURL;
NSString *const kBio;
NSString *const kWebsite;

NSString *const kCounts;
NSString *const kCountMedia;
NSString *const kCountFollows;
NSString *const kCountFollowedBy;

NSString *const kTagMediaCount;
NSString *const kTagName;

NSString *const kNextURL;
NSString *const kNextMaxId;
NSString *const kNextMaxLikeId;
NSString *const kNextMaxTagId;
NSString *const kNextCursor;

NSString *const kMaxId;
NSString *const kMaxLikeId;
NSString *const kMaxTagId;
NSString *const kCursor;

#define IKNotNull(obj) (obj && (![obj isEqual:[NSNull null]]) && (![obj isEqual:@"<null>"]) )
#define IKValidDictionary(dict) (IKNotNull(dict) && [dict isKindOfClass:[NSDictionary class]])
#define IKValidArray(array) (IKNotNull(array) && [array isKindOfClass:[NSArray class]])
#define IKValidString(str) (IKNotNull(str) && [str isKindOfClass:[NSString class]])
#define IKValidNumber(num) (IKNotNull(num) && [num isKindOfClass:[NSNumber class]])
