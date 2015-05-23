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
    if (self && ik_dictionaryIsValid(info)) {
        
        if (ik_dictionaryIsValid(info[kUser])) {
            _user = [[InstagramUser alloc] initWithInfo:info[kUser]];
        }
        _userHasLiked = ik_safeBOOL(info[kUserHasLiked]);
        _createdDate = [[NSDate alloc] initWithTimeIntervalSince1970:[ik_safeString(info[kCreatedDate]) doubleValue]];
        
        _link = ik_safeString(info[kLink]);
        
        if (ik_dictionaryIsValid(info[kCaption])) {
            _caption = [[InstagramComment alloc] initWithInfo:info[kCaption]];
        }
        
        _likesCount = [ik_safeNumber((info[kLikes])[kCount]) integerValue];
        mLikes = [[NSMutableArray alloc] init];
        if (ik_arrayIsValid(info[kLikes][kData])) {
            for (NSDictionary *userInfo in info[kLikes][kData]) {
                if (ik_dictionaryIsValid(userInfo)) {
                    InstagramUser *user = [[InstagramUser alloc] initWithInfo:userInfo];
                    [mLikes addObject:user];
                }
            }
        }
        
        _commentCount = [ik_safeNumber((info[kComments])[kCount]) integerValue];
        
        mComments = [[NSMutableArray alloc] init];
        if (ik_arrayIsValid(info[kComments][kData])) {
            for (NSDictionary *commentInfo in (info[kComments])[kData]) {
                if (ik_dictionaryIsValid(commentInfo)) {
                    InstagramComment *comment = [[InstagramComment alloc] initWithInfo:commentInfo];
                    [mComments addObject:comment];
                }
            }
        }

        _tags = [[NSArray alloc] initWithArray:ik_safeArray(info[kTags])];
        
        if (ik_dictionaryIsValid(info[kLocation])) {
            _location = [[InstagramLocation alloc] initWithInfo:info[kLocation]];
        }
        
        _filter = ik_safeString(info[kFilter]);
        
        if (ik_dictionaryIsValid(info[kImages])) {
            [self initializeImages:(info[kImages])];
        }
        
        NSString* mediaType = ik_safeString(info[kType]);
        _isVideo = [mediaType isEqualToString:kMediaTypeVideo];
        if (_isVideo && ik_dictionaryIsValid(info[kVideos])) {
            [self initializeVideos:info[kVideos]];
        }
    }
    return self;
}

- (void)initializeImages:(NSDictionary *)imagesInfo
{
    NSDictionary *thumbInfo = ik_safeDictionary(imagesInfo[kThumbnail]);
    _thumbnailURL = [[NSURL alloc] initWithString:ik_safeString(thumbInfo[kURL])];
    _thumbnailFrameSize = CGSizeMake([ik_safeNumber(thumbInfo[kWidth]) floatValue], [ik_safeNumber(thumbInfo[kHeight]) floatValue]);
    
    NSDictionary *lowResInfo = ik_safeDictionary(imagesInfo[kLowResolution]);
    _lowResolutionImageURL = [[NSURL alloc] initWithString:ik_safeString(lowResInfo[kURL])];
    _lowResolutionImageFrameSize = CGSizeMake([ik_safeNumber(lowResInfo[kWidth]) floatValue], [ik_safeNumber(lowResInfo[kHeight]) floatValue]);
    
    NSDictionary *standardResInfo = ik_safeDictionary(imagesInfo[kStandardResolution]);
    _standardResolutionImageURL = [[NSURL alloc] initWithString:ik_safeString(standardResInfo[kURL])];
    _standardResolutionImageFrameSize = CGSizeMake([ik_safeNumber(standardResInfo[kWidth]) floatValue], [ik_safeNumber(standardResInfo[kHeight]) floatValue]);
}

- (void)initializeVideos:(NSDictionary *)videosInfo
{
    NSDictionary *lowResInfo = ik_safeDictionary(videosInfo[kLowResolution]);
    _lowResolutionVideoURL = [[NSURL alloc] initWithString:ik_safeString(lowResInfo[kURL])];
    _lowResolutionVideoFrameSize = CGSizeMake([ik_safeNumber(lowResInfo[kWidth]) floatValue], [ik_safeNumber(lowResInfo[kHeight]) floatValue]);
    
    NSDictionary *standardResInfo = ik_safeDictionary(videosInfo[kStandardResolution]);
    _standardResolutionVideoURL = [[NSURL alloc] initWithString:ik_safeString(standardResInfo[kURL])];
    _standardResolutionVideoFrameSize = CGSizeMake([ik_safeNumber(standardResInfo[kWidth]) floatValue], [ik_safeNumber(standardResInfo[kHeight]) floatValue]);
}


- (BOOL)isEqualToMedia:(InstagramMedia *)media {
    return [super isEqualToModel:media];
}

@end
