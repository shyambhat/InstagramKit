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

- (id)initWithInfo:(NSDictionary *)info;

@end


#define kID @"id"
#define kCount @"count"
#define kURL @"url"
#define kHeight @"height"
#define kWidth @"width"
#define kData @"data"
#define kLatitude @"latitude"
#define kLongitude @"longitude"

#define kThumbnail @"thumbnail"
#define kLowResolution @"low_resolution"
#define kStandardResolution @"standard_resolution"

#define kMediaTypeImage @"image"
#define kMediaTypeVideo @"video"

#define kUser @"user"
#define kCreatedDate @"created_time"
#define kLink @"link"
#define kCaption @"caption"
#define kLikes @"likes"
#define kComments @"comments"
#define kFilter @"filter"
#define kTags @"tags"
#define kImages @"images"
#define kVideos @"videos"
#define kLocation @"location"
#define kType @"type"

#define kCreator @"from"
#define kText @"text"

#define kUsername @"username"
#define kFullName @"full_name"
#define kFirstName @"first_name"
#define kLastName @"last_name"
#define kProfilePictureURL @"profile_picture"
#define kBio @"bio"
#define kWebsite @"website"

#define kCounts @"counts"
#define kCountMedia @"media"
#define kCountFollows @"follows"
#define kCountFollowedBy @"followed_by"

#define kTagMediaCount @"media_count"
#define kTagName @"name"

#define kNextURL @"next_url"
#define kNextMaxId @"next_max_id"
#define kNextMaxLikeId @"next_max_like_id"
#define kNextMaxTagId @"next_max_tag_id"

#define kMaxId @"max_id"
#define kMaxLikeId @"max_like_id"
#define kMaxTagId @"max_tag_id"

#define IKNotNull(obj) (obj && (![obj isEqual:[NSNull null]]) && (![obj isEqual:@"<null>"]) )
