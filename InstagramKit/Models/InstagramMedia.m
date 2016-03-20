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

#import "InstagramMedia.h"
#import "InstagramUser.h"
#import "InstagramComment.h"
#import "UserInPhoto.h"
#import "InstagramLocation.h"

@interface InstagramMedia ()

@property (nonatomic, strong) InstagramUser *user;
@property (nonatomic, assign) BOOL userHasLiked;
@property (nonatomic, strong) NSDate *createdDate;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, strong) InstagramComment *caption;
@property (nonatomic, strong) NSMutableArray *mLikes;
@property (nonatomic, assign) NSInteger likesCount;
@property (nonatomic, strong) NSMutableArray *mComments;
@property (nonatomic, assign) NSInteger commentsCount;
@property (nonatomic, strong) NSMutableArray *mUsersInPhoto;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, assign) CLLocationCoordinate2D location;
@property (nonatomic, copy) NSString *locationId;
@property (nonatomic, copy) NSString *locationName;
@property (nonatomic, copy) NSString *filter;
@property (nonatomic, strong) NSURL *thumbnailURL;
@property (nonatomic, assign) CGSize thumbnailFrameSize;
@property (nonatomic, strong) NSURL *lowResolutionImageURL;
@property (nonatomic, assign) CGSize lowResolutionImageFrameSize;
@property (nonatomic, strong) NSURL *standardResolutionImageURL;
@property (nonatomic, assign) CGSize standardResolutionImageFrameSize;
@property (nonatomic, assign) BOOL isVideo;
@property (nonatomic, strong) NSURL *lowResolutionVideoURL;
@property (nonatomic, assign) CGSize lowResolutionVideoFrameSize;
@property (nonatomic, strong) NSURL *standardResolutionVideoURL;
@property (nonatomic, assign) CGSize standardResolutionVideoFrameSize;

@end

@implementation InstagramMedia

- (instancetype)initWithInfo:(NSDictionary *)info
{
    self = [super initWithInfo:info];
    if (self && IKNotNull(info)) {
        
        self.user = [[InstagramUser alloc] initWithInfo:info[kUser]];
        self.userHasLiked = [info[kUserHasLiked] boolValue];
        self.createdDate = [[NSDate alloc] initWithTimeIntervalSince1970:[info[kCreatedDate] doubleValue]];
        self.link = [[NSString alloc] initWithString:info[kLink]];
        self.caption = [[InstagramComment alloc] initWithInfo:info[kCaption]];
        
        self.mLikes = [[NSMutableArray alloc] init];
        NSDictionary *likesDictionary = info[kLikes];
        if ([likesDictionary isKindOfClass:[NSDictionary class]]) {
            for (NSDictionary *userInfo in likesDictionary[kData]) {
                InstagramUser *user = [[InstagramUser alloc] initWithInfo:userInfo];
                [self.mLikes addObject:user];
            }
            NSNumber *likesCount = likesDictionary[kCount];
            self.likesCount = likesCount.integerValue;
        }
        
        NSDictionary *commentsDictionary = info[kComments];
        self.mComments = [[NSMutableArray alloc] init];
        if ([commentsDictionary isKindOfClass:[NSDictionary class]]) {
            for (NSDictionary *commentInfo in commentsDictionary[kData]) {
                InstagramComment *comment = [[InstagramComment alloc] initWithInfo:commentInfo];
                [self.mComments addObject:comment];
            }
            NSNumber *commentsCount = commentsDictionary[kCount];
            self.commentsCount = commentsCount.integerValue;
        }
        
        self.mUsersInPhoto = [[NSMutableArray alloc] init];
        for (NSDictionary *userInfo in info[kUsersInPhoto]) {
            UserInPhoto *userInPhoto = [[UserInPhoto alloc] initWithInfo:userInfo];
            [self.mUsersInPhoto addObject:userInPhoto];
        }

        self.tags = [[NSArray alloc] initWithArray:info[kTags]];
        
        if (IKNotNull(info[kLocation])) {
            id locationId = IKNotNull(info[kLocation][kID]) ? info[kLocation][kID] : nil;
            self.locationId = ([locationId isKindOfClass:[NSString class]]) ? locationId : [locationId stringValue];
            self.locationName = IKNotNull(info[kLocation][kLocationName]) ? info[kLocation][kLocationName] : nil;
            self.location = CLLocationCoordinate2DMake([(info[kLocation])[kLocationLatitude] doubleValue], [(info[kLocation])[kLocationLongitude] doubleValue]);
        }
        
        self.filter = info[kFilter];
        
        [self initializeImages:info[kImages]];
        
        NSString *mediaType = info[kType];
        self.isVideo = [mediaType isEqualToString:[NSString stringWithFormat:@"%@",kMediaTypeVideo]];
        if (self.isVideo) {
            [self initializeVideos:info[kVideos]];
        }
    }
    return self;
}

- (void)initializeImages:(NSDictionary *)imagesInfo
{
    NSDictionary *thumbInfo = imagesInfo[kThumbnail];
    self.thumbnailURL = (IKNotNull(thumbInfo[kURL])) ? [[NSURL alloc] initWithString:thumbInfo[kURL]] : nil;
    self.thumbnailFrameSize = CGSizeMake([thumbInfo[kWidth] floatValue], [thumbInfo[kHeight] floatValue]);
    
    NSDictionary *lowResInfo = imagesInfo[kLowResolution];
    self.lowResolutionImageURL = IKNotNull(lowResInfo[kURL])? [[NSURL alloc] initWithString:lowResInfo[kURL]] : nil;
    self.lowResolutionImageFrameSize = CGSizeMake([lowResInfo[kWidth] floatValue], [lowResInfo[kHeight] floatValue]);
    
    NSDictionary *standardResInfo = imagesInfo[kStandardResolution];
    self.standardResolutionImageURL = IKNotNull(standardResInfo[kURL])? [[NSURL alloc] initWithString:standardResInfo[kURL]] : nil;
    self.standardResolutionImageFrameSize = CGSizeMake([standardResInfo[kWidth] floatValue], [standardResInfo[kHeight] floatValue]);
}

- (void)initializeVideos:(NSDictionary *)videosInfo
{
    NSDictionary *lowResInfo = videosInfo[kLowResolution];
    self.lowResolutionVideoURL = IKNotNull(lowResInfo[kURL]) ? [[NSURL alloc] initWithString:lowResInfo[kURL]] : nil;
    self.lowResolutionVideoFrameSize = CGSizeMake([lowResInfo[kWidth] floatValue], [lowResInfo[kHeight] floatValue]);
    
    NSDictionary *standardResInfo = videosInfo[kStandardResolution];
    self.standardResolutionVideoURL = IKNotNull(standardResInfo[kURL])? [[NSURL alloc] initWithString:standardResInfo[kURL]] : nil;
    self.standardResolutionVideoFrameSize = CGSizeMake([standardResInfo[kWidth] floatValue], [standardResInfo[kHeight] floatValue]);
}

#pragma Getters 

- (NSArray *)likes
{
    return [NSArray arrayWithArray:self.mLikes];
}

- (NSArray *)comments
{
    return [NSArray arrayWithArray:self.mComments];
}

- (NSInteger)commentCount
{
    return [self.mComments count];
}

- (NSArray *)usersInPhoto
{
    return [NSArray arrayWithArray:self.mUsersInPhoto];
}

#pragma mark - Equality

- (BOOL)isEqualToMedia:(InstagramMedia *)media {
    return [super isEqualToModel:media];
}

#pragma mark - NSCoding

+ (BOOL)supportsSecureCoding
{
    return YES;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super initWithCoder:decoder])) {
        self.user = [decoder decodeObjectOfClass:[InstagramUser class] forKey:kUser];
        self.userHasLiked = [decoder decodeBoolForKey:kUserHasLiked];
        self.createdDate = [decoder decodeObjectOfClass:[NSDate class] forKey:kCreatedDate];
        self.link = [decoder decodeObjectOfClass:[NSString class] forKey:kLink];
        self.caption = [decoder decodeObjectOfClass:[NSString class] forKey:kCaption];
        self.mLikes = [[decoder decodeObjectOfClass:[NSArray class] forKey:kLikes] mutableCopy];
        self.mComments = [[decoder decodeObjectOfClass:[NSArray class] forKey:kComments] mutableCopy];
        self.mUsersInPhoto = [[decoder decodeObjectOfClass:[NSArray class] forKey:kUsersInPhoto] mutableCopy];
        self.tags = [decoder decodeObjectOfClass:[NSArray class] forKey:kTags];
        
        CLLocationCoordinate2D coordinates;
        coordinates.latitude = [decoder decodeDoubleForKey:kLocationLatitude];
        coordinates.longitude = [decoder decodeDoubleForKey:kLocationLongitude];
        self.location = coordinates;
        self.locationName = [decoder decodeObjectOfClass:[NSString class] forKey:kLocationName];
        
        self.filter = [decoder decodeObjectOfClass:[NSString class] forKey:kFilter];
        
        self.thumbnailURL = [decoder decodeObjectOfClass:[NSString class] forKey:[NSString stringWithFormat:@"%@url",kThumbnail]];
        self.thumbnailFrameSize = [decoder decodeCGSizeForKey:[NSString stringWithFormat:@"%@size",kThumbnail]];
        
        self.isVideo = [decoder decodeBoolForKey:kMediaTypeVideo];
        
        if (!self.isVideo) {
            self.lowResolutionImageURL = [decoder decodeObjectOfClass:[NSString class] forKey:[NSString stringWithFormat:@"%@url",kLowResolution]];
            self.lowResolutionImageFrameSize = [decoder decodeCGSizeForKey:[NSString stringWithFormat:@"%@size",kLowResolution]];
            self.standardResolutionImageURL = [decoder decodeObjectOfClass:[NSString class] forKey:[NSString stringWithFormat:@"%@url",kStandardResolution]];
            self.standardResolutionImageFrameSize = [decoder decodeCGSizeForKey:[NSString stringWithFormat:@"%@size",kStandardResolution]];
        }
        else
        {
            self.lowResolutionVideoURL = [decoder decodeObjectOfClass:[NSString class] forKey:[NSString stringWithFormat:@"%@url",kLowResolution]];
            self.lowResolutionVideoFrameSize = [decoder decodeCGSizeForKey:[NSString stringWithFormat:@"%@size",kLowResolution]];
            self.standardResolutionVideoURL = [decoder decodeObjectOfClass:[NSString class] forKey:[NSString stringWithFormat:@"%@url",kStandardResolution]];
            self.standardResolutionVideoFrameSize = [decoder decodeCGSizeForKey:[NSString stringWithFormat:@"%@size",kStandardResolution]];
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];

    [encoder encodeObject:self.user forKey:kUser];
    [encoder encodeBool:self.userHasLiked forKey:kUserHasLiked];
    [encoder encodeObject:self.createdDate forKey:kCreatedDate];
    [encoder encodeObject:self.link forKey:kLink];
    [encoder encodeObject:self.caption forKey:kCaption];
    [encoder encodeObject:self.mLikes forKey:kLikes];
    [encoder encodeObject:self.mComments forKey:kComments];
    [encoder encodeObject:self.mUsersInPhoto forKey:kUsersInPhoto];
    [encoder encodeObject:self.tags forKey:kTags];
    [encoder encodeDouble:self.location.latitude forKey:kLocationLatitude];
    [encoder encodeDouble:self.location.longitude forKey:kLocationLongitude];
    [encoder encodeObject:self.locationName forKey:kLocationName];
    [encoder encodeObject:self.filter forKey:kFilter];
    [encoder encodeObject:self.thumbnailURL forKey:[NSString stringWithFormat:@"%@url",kThumbnail]];
    [encoder encodeCGSize:self.thumbnailFrameSize forKey:[NSString stringWithFormat:@"%@size",kThumbnail]];
    [encoder encodeBool:self.isVideo forKey:kMediaTypeVideo];

    if (!self.isVideo) {
        [encoder encodeObject:self.lowResolutionImageURL forKey:[NSString stringWithFormat:@"%@url",kLowResolution]];
        [encoder encodeCGSize:self.lowResolutionImageFrameSize forKey:[NSString stringWithFormat:@"%@size",kLowResolution]];
        [encoder encodeObject:self.standardResolutionImageURL forKey:[NSString stringWithFormat:@"%@url",kStandardResolution]];
        [encoder encodeCGSize:self.standardResolutionImageFrameSize forKey:[NSString stringWithFormat:@"%@size",kStandardResolution]];
    }
    else
    {
        [encoder encodeObject:self.lowResolutionVideoURL forKey:[NSString stringWithFormat:@"%@url",kLowResolution]];
        [encoder encodeCGSize:self.lowResolutionVideoFrameSize forKey:[NSString stringWithFormat:@"%@size",kLowResolution]];
        [encoder encodeObject:self.standardResolutionVideoURL forKey:[NSString stringWithFormat:@"%@url",kStandardResolution]];
        [encoder encodeCGSize:self.standardResolutionVideoFrameSize forKey:[NSString stringWithFormat:@"%@size",kStandardResolution]];
    }

}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    InstagramMedia *copy = [super copyWithZone:zone];
    copy->_user = [self.user copy];
    copy->_userHasLiked = self.userHasLiked;
    copy->_createdDate = [self.createdDate copy];
    copy->_link = [self.link copy];
    copy->_caption = [self.caption copy];
    copy->_mLikes = [self.mLikes copy];
    copy->_mComments = [self.mComments copy];
    copy->_mUsersInPhoto = [self.mUsersInPhoto copy];
    copy->_tags = [self.tags copy];
    copy->_location = self.location;
    copy->_locationName = [self.locationName copy];
    copy->_filter = [self.filter copy];
    copy->_thumbnailURL = [self.thumbnailURL copy];
    copy->_thumbnailFrameSize = self.thumbnailFrameSize;
    copy->_isVideo = self.isVideo;
    copy->_lowResolutionImageURL = [self.lowResolutionImageURL copy];
    copy->_lowResolutionImageFrameSize = self.lowResolutionImageFrameSize;
    copy->_standardResolutionImageURL = [self.standardResolutionImageURL copy];
    copy->_standardResolutionImageFrameSize = self.standardResolutionImageFrameSize;
    copy->_lowResolutionVideoURL = [self.lowResolutionVideoURL copy];
    copy->_lowResolutionVideoFrameSize = self.lowResolutionVideoFrameSize;
    copy->_standardResolutionVideoURL = [self.standardResolutionVideoURL copy];
    copy->_standardResolutionVideoFrameSize = self.standardResolutionVideoFrameSize;
    return copy;
}


@end
