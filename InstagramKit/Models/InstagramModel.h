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

extern NSString *const kID;
extern NSString *const kCount;
extern NSString *const kURL;
extern NSString *const kHeight;
extern NSString *const kWidth;
extern NSString *const kData;

extern NSString *const kThumbnail;
extern NSString *const kLowResolution;
extern NSString *const kStandardResolution;

extern NSString *const kMediaTypeImage;
extern NSString *const kMediaTypeVideo;

extern NSString *const kUser;
extern NSString *const kUserHasLiked;
extern NSString *const kCreatedDate;
extern NSString *const kLink;
extern NSString *const kCaption;
extern NSString *const kLikes;
extern NSString *const kComments;
extern NSString *const kFilter;
extern NSString *const kTags;
extern NSString *const kImages;
extern NSString *const kVideos;
extern NSString *const kLocation;
extern NSString *const kType;

extern NSString *const kCreator;
extern NSString *const kText;

extern NSString *const kUsername;
extern NSString *const kFullName;
extern NSString *const kFirstName;
extern NSString *const kLastName;
extern NSString *const kProfilePictureURL;
extern NSString *const kBio;
extern NSString *const kWebsite;

extern NSString *const kCounts;
extern NSString *const kCountMedia;
extern NSString *const kCountFollows;
extern NSString *const kCountFollowedBy;

extern NSString *const kTagMediaCount;
extern NSString *const kTagName;

extern NSString *const kNextURL;
extern NSString *const kNextMaxId;
extern NSString *const kNextMaxLikeId;
extern NSString *const kNextMaxTagId;
extern NSString *const kNextCursor;

extern NSString *const kMaxId;
extern NSString *const kMaxLikeId;
extern NSString *const kMaxTagId;
extern NSString *const kCursor;

extern NSString *const kLocationLatitude;
extern NSString *const kLocationLongitude;
extern NSString *const kLocationName;


#define IKNotNull(obj) (obj && (![obj isEqual:[NSNull null]]) && (![obj isEqual:@"<null>"]) )
#define IKValidDictionary(dict) (IKNotNull(dict) && [dict isKindOfClass:[NSDictionary class]])
#define IKValidArray(array) (IKNotNull(array) && [array isKindOfClass:[NSArray class]])
#define IKValidString(str) (IKNotNull(str) && [str isKindOfClass:[NSString class]])
#define IKValidNumber(num) (IKNotNull(num) && [num isKindOfClass:[NSNumber class]])
