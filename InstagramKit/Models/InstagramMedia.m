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
#import "InstagramLocation.h"

@interface InstagramMedia ()
{
    NSMutableArray *mLikes;
    NSMutableArray *mComments;
}
@end

@implementation InstagramMedia
@synthesize likes = mLikes;
@synthesize comments = mComments;

- (instancetype)initWithInfo:(NSDictionary *)info
{
    self = [super initWithInfo:info];
    if (self && IKNotNull(info)) {
        
        _user = [[InstagramUser alloc] initWithInfo:info[kUser]];
        _userHasLiked = [info[kUserHasLiked] boolValue];
        _createdDate = [[NSDate alloc] initWithTimeIntervalSince1970:[info[kCreatedDate] doubleValue]];
        _link = [[NSString alloc] initWithString:info[kLink]];
        _caption = [[InstagramComment alloc] initWithInfo:info[kCaption]];
        _likesCount = [(info[kLikes])[kCount] integerValue];
        mLikes = [[NSMutableArray alloc] init];
        for (NSDictionary *userInfo in (info[kLikes])[kData]) {
            InstagramUser *user = [[InstagramUser alloc] initWithInfo:userInfo];
            [mLikes addObject:user];
        }
        
        _commentCount = [(info[kComments])[kCount] integerValue];
        mComments = [[NSMutableArray alloc] init];
        for (NSDictionary *commentInfo in (info[kComments])[kData]) {
            InstagramComment *comment = [[InstagramComment alloc] initWithInfo:commentInfo];
            [mComments addObject:comment];
        }
        _tags = [[NSArray alloc] initWithArray:info[kTags]];
        
        if (IKNotNull(info[kLocation])) {
            _location = CLLocationCoordinate2DMake([(info[kLocation])[kLocationLatitude] doubleValue], [(info[kLocation])[kLocationLongitude] doubleValue]);
            if (IKNotNull(info[kLocation][kLocationName]))
            {
                _locationName = info[kLocation][kLocationName];
            }
        }
        
        _filter = info[kFilter];
        
        [self initializeImages:info[kImages]];
        
        NSString* mediaType = info[kType];
        _isVideo = [mediaType isEqualToString:[NSString stringWithFormat:@"%@",kMediaTypeVideo]];
        if (_isVideo) {
            [self initializeVideos:info[kVideos]];
        }
    }
    return self;
}

- (void)initializeImages:(NSDictionary *)imagesInfo
{
    NSDictionary *thumbInfo = imagesInfo[kThumbnail];
    _thumbnailURL = [[NSURL alloc] initWithString:thumbInfo[kURL]];
    _thumbnailFrameSize = CGSizeMake([thumbInfo[kWidth] floatValue], [thumbInfo[kHeight] floatValue]);
    
    NSDictionary *lowResInfo = imagesInfo[kLowResolution];
    _lowResolutionImageURL = [[NSURL alloc] initWithString:lowResInfo[kURL]];
    _lowResolutionImageFrameSize = CGSizeMake([lowResInfo[kWidth] floatValue], [lowResInfo[kHeight] floatValue]);
    
    NSDictionary *standardResInfo = imagesInfo[kStandardResolution];
    _standardResolutionImageURL = [[NSURL alloc] initWithString:standardResInfo[kURL]];
    _standardResolutionImageFrameSize = CGSizeMake([standardResInfo[kWidth] floatValue], [standardResInfo[kHeight] floatValue]);
}

- (void)initializeVideos:(NSDictionary *)videosInfo
{
    NSDictionary *lowResInfo = videosInfo[kLowResolution];
    _lowResolutionVideoURL = [[NSURL alloc] initWithString:lowResInfo[kURL]];
    _lowResolutionVideoFrameSize = CGSizeMake([lowResInfo[kWidth] floatValue], [lowResInfo[kHeight] floatValue]);
    
    NSDictionary *standardResInfo = videosInfo[kStandardResolution];
    _standardResolutionVideoURL = [[NSURL alloc] initWithString:standardResInfo[kURL]];
    _standardResolutionVideoFrameSize = CGSizeMake([standardResInfo[kWidth] floatValue], [standardResInfo[kHeight] floatValue]);
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
    if ((self = [self init])) {
        _user = [decoder decodeObjectOfClass:[InstagramUser class] forKey:kUser];
        _userHasLiked = [decoder decodeBoolForKey:kUserHasLiked];
        _createdDate = [decoder decodeObjectOfClass:[NSDate class] forKey:kCreatedDate];
        _link = [decoder decodeObjectOfClass:[NSString class] forKey:kLink];
        _caption = [decoder decodeObjectOfClass:[NSString class] forKey:kCaption];
        _likesCount = [decoder decodeIntegerForKey:[NSString stringWithFormat:@"%@%@",kLikes,kCount]];
        mLikes = [[decoder decodeObjectOfClass:[NSArray class] forKey:kLikes] mutableCopy];
        _commentCount = [decoder decodeIntegerForKey:[NSString stringWithFormat:@"%@%@",kComments,kCount]];
        mComments = [[decoder decodeObjectOfClass:[NSArray class] forKey:kComments] mutableCopy];
        _tags = [decoder decodeObjectOfClass:[NSArray class] forKey:kTags];
        
        CLLocationCoordinate2D coordinates;
        coordinates.latitude = [decoder decodeDoubleForKey:kLocationLatitude];
        coordinates.longitude = [decoder decodeDoubleForKey:kLocationLongitude];
        _location = coordinates;
        _locationName = [decoder decodeObjectOfClass:[NSString class] forKey:kLocationName];
        
        _filter = [decoder decodeObjectOfClass:[NSString class] forKey:kFilter];
        
        _thumbnailURL = [decoder decodeObjectOfClass:[NSString class] forKey:[NSString stringWithFormat:@"%@url",kThumbnail]];
        _thumbnailFrameSize = [decoder decodeCGSizeForKey:[NSString stringWithFormat:@"%@size",kThumbnail]];
        
        _isVideo = [decoder decodeBoolForKey:kMediaTypeVideo];
        
        if (!_isVideo) {
            _lowResolutionImageURL = [decoder decodeObjectOfClass:[NSString class] forKey:[NSString stringWithFormat:@"%@url",kLowResolution]];
            _lowResolutionImageFrameSize = [decoder decodeCGSizeForKey:[NSString stringWithFormat:@"%@size",kLowResolution]];
            _standardResolutionImageURL = [decoder decodeObjectOfClass:[NSString class] forKey:[NSString stringWithFormat:@"%@url",kStandardResolution]];
            _standardResolutionImageFrameSize = [decoder decodeCGSizeForKey:[NSString stringWithFormat:@"%@size",kStandardResolution]];
        }
        else
        {
            _lowResolutionVideoURL = [decoder decodeObjectOfClass:[NSString class] forKey:[NSString stringWithFormat:@"%@url",kLowResolution]];
            _lowResolutionVideoFrameSize = [decoder decodeCGSizeForKey:[NSString stringWithFormat:@"%@size",kLowResolution]];
            _standardResolutionVideoURL = [decoder decodeObjectOfClass:[NSString class] forKey:[NSString stringWithFormat:@"%@url",kStandardResolution]];
            _standardResolutionVideoFrameSize = [decoder decodeCGSizeForKey:[NSString stringWithFormat:@"%@size",kStandardResolution]];
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_user forKey:kUser];
    [encoder encodeBool:_userHasLiked forKey:kUserHasLiked];
    [encoder encodeObject:_createdDate forKey:kCreatedDate];
    [encoder encodeObject:_link forKey:kLink];
    [encoder encodeObject:_caption forKey:kCaption];
    [encoder encodeInteger:_likesCount forKey:[NSString stringWithFormat:@"%@%@",kLikes,kCount]];
    [encoder encodeObject:mLikes forKey:kLikes];
    [encoder encodeInteger:_commentCount forKey:[NSString stringWithFormat:@"%@%@",kComments,kCount]];
    [encoder encodeObject:_tags forKey:kTags];
    [encoder encodeDouble:_location.latitude forKey:kLocationLatitude];
    [encoder encodeDouble:_location.longitude forKey:kLocationLongitude];
    [encoder encodeObject:_locationName forKey:kLocationName];
    [encoder encodeObject:_filter forKey:kFilter];
    [encoder encodeObject:_thumbnailURL forKey:[NSString stringWithFormat:@"%@url",kThumbnail]];
    [encoder encodeCGSize:_thumbnailFrameSize forKey:[NSString stringWithFormat:@"%@size",kThumbnail]];
    [encoder encodeBool:_isVideo forKey:kMediaTypeVideo];

    if (!_isVideo) {
        [encoder encodeObject:_lowResolutionImageURL forKey:[NSString stringWithFormat:@"%@url",kLowResolution]];
        [encoder encodeCGSize:_lowResolutionImageFrameSize forKey:[NSString stringWithFormat:@"%@size",kLowResolution]];
        [encoder encodeObject:_standardResolutionImageURL forKey:[NSString stringWithFormat:@"%@url",kStandardResolution]];
        [encoder encodeCGSize:_standardResolutionImageFrameSize forKey:[NSString stringWithFormat:@"%@size",kStandardResolution]];
    }
    else
    {
        [encoder encodeObject:_lowResolutionVideoURL forKey:[NSString stringWithFormat:@"%@url",kLowResolution]];
        [encoder encodeCGSize:_lowResolutionVideoFrameSize forKey:[NSString stringWithFormat:@"%@size",kLowResolution]];
        [encoder encodeObject:_standardResolutionVideoURL forKey:[NSString stringWithFormat:@"%@url",kStandardResolution]];
        [encoder encodeCGSize:_standardResolutionVideoFrameSize forKey:[NSString stringWithFormat:@"%@size",kStandardResolution]];
    }

}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    InstagramMedia *copy = [super copyWithZone:zone];
    copy->_user = [_user copy];
    copy->_userHasLiked = _userHasLiked;
    copy->_createdDate = [_createdDate copy];
    copy->_link = [_link copy];
    copy->_caption = [_caption copy];
    copy->_likesCount = _likesCount;
    copy->mLikes = [mLikes copy];
    copy->_commentCount = _commentCount;
    copy->mComments = [mComments copy];
    copy->_tags = [_tags copy];
    copy->_location = _location;
    copy->_locationName = [_locationName copy];
    copy->_filter = [_filter copy];
    copy->_thumbnailURL = [_thumbnailURL copy];
    copy->_thumbnailFrameSize = _thumbnailFrameSize;
    copy->_isVideo = _isVideo;
    copy->_lowResolutionImageURL = [_lowResolutionImageURL copy];
    copy->_lowResolutionImageFrameSize = _lowResolutionImageFrameSize;
    copy->_standardResolutionImageURL = [_standardResolutionImageURL copy];
    copy->_standardResolutionImageFrameSize = _standardResolutionImageFrameSize;
    copy->_lowResolutionVideoURL = [_lowResolutionVideoURL copy];
    copy->_lowResolutionVideoFrameSize = _lowResolutionVideoFrameSize;
    copy->_standardResolutionVideoURL = [_standardResolutionVideoURL copy];
    copy->_standardResolutionVideoFrameSize = _standardResolutionVideoFrameSize;
    return copy;
}


@end
