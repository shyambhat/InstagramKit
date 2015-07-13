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

#import "InstagramModel.h"

NSString *const kID = @"id";
NSString *const kCount = @"count";
NSString *const kURL = @"url";
NSString *const kHeight = @"height";
NSString *const kWidth = @"width";
NSString *const kData = @"data";

NSString *const kThumbnail = @"thumbnail";
NSString *const kLowResolution = @"low_resolution";
NSString *const kStandardResolution = @"standard_resolution";

NSString *const kMediaTypeImage = @"image";
NSString *const kMediaTypeVideo = @"video";

NSString *const kUser = @"user";
NSString *const kUserHasLiked = @"user_has_liked";
NSString *const kCreatedDate = @"created_time";
NSString *const kLink = @"link";
NSString *const kCaption = @"caption";
NSString *const kLikes = @"likes";
NSString *const kComments = @"comments";
NSString *const kFilter = @"filter";
NSString *const kTags = @"tags";
NSString *const kImages = @"images";
NSString *const kVideos = @"videos";
NSString *const kLocation = @"location";
NSString *const kType = @"type";

NSString *const kCreator = @"from";
NSString *const kText = @"text";

NSString *const kUsername = @"username";
NSString *const kFullName = @"full_name";
NSString *const kFirstName = @"first_name";
NSString *const kLastName = @"last_name";
NSString *const kProfilePictureURL = @"profile_picture";
NSString *const kBio = @"bio";
NSString *const kWebsite = @"website";

NSString *const kCounts = @"counts";
NSString *const kCountMedia = @"media";
NSString *const kCountFollows = @"follows";
NSString *const kCountFollowedBy = @"followed_by";

NSString *const kTagMediaCount = @"media_count";
NSString *const kTagName = @"name";

NSString *const kLocationLatitude = @"latitude";
NSString *const kLocationLongitude = @"longitude";
NSString *const kLocationName = @"name";

NSString *const kNextURL = @"next_url";
NSString *const kNextMaxId = @"next_max_id";
NSString *const kNextMaxLikeId = @"next_max_like_id";
NSString *const kNextMaxTagId = @"next_max_tag_id";
NSString *const kNextCursor = @"next_cursor";

NSString *const kMaxId = @"max_id";
NSString *const kMaxLikeId = @"max_like_id";
NSString *const kMaxTagId = @"max_tag_id";
NSString *const kCursor = @"cursor";


@implementation InstagramModel

- (instancetype)initWithInfo:(NSDictionary *)info
{
    self = [super init];
    if (self && IKNotNull(info)) {
        if (IKNotNull(info[kID])) {
            _Id = [[NSString alloc] initWithString:info[kID]];
        }
    }
    return self;
}

#pragma mark - Equality

- (BOOL)isEqualToModel:(InstagramModel *)model {
    
    if (self == model) {
        return YES;
    }
    if (model && [model respondsToSelector:@selector(Id)]) {
        return [self.Id isEqualToString:model.Id];
    }
    return NO;
}

#pragma mark - NSCoding

+ (BOOL)supportsSecureCoding
{
    return YES;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [self init])) {
        _Id = [decoder decodeObjectOfClass:[NSString class] forKey:kID];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_Id forKey:kID];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    InstagramModel *copy = [[InstagramModel allocWithZone:zone] init];
    copy->_Id = [_Id copy];
    return copy;
}

@end
