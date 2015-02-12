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
#import "NSDictionary+IKValidation.h"


@interface InstagramMedia ()
{
    NSMutableArray *mLikes;
    NSMutableArray *mComments;
}
@end

@implementation InstagramMedia
@synthesize likes = mLikes;
@synthesize comments = mComments;

- (id)initWithInfo:(NSDictionary *)info
{
    self = [super initWithInfo:info];
    if (self && [info isKindOfClass:[NSDictionary class]]) {
        
        _user = [[InstagramUser alloc] initWithInfo:info[kUser]];
        _createdDate = [info ik_dateForKey:kCreatedDate];
        _link = [info ik_stringForKey:kLink];
        _caption = [[InstagramComment alloc] initWithInfo:info[kCaption]];
        _likesCount = [[[info ik_dictionaryForKey:kLikes] ik_numberForKey:kCount] integerValue];
        
        mLikes = [[NSMutableArray alloc] init];
        for (NSDictionary *userInfo in ([[info ik_dictionaryForKey:kLikes] ik_arrayForKey:kData])) {
            InstagramUser *user = [[InstagramUser alloc] initWithInfo:userInfo];
            [mLikes addObject:user];
        }
        
        _commentCount = [[[info ik_dictionaryForKey:kComments] ik_numberForKey:kCount] integerValue];
        mComments = [[NSMutableArray alloc] init];
        for (NSDictionary *commentInfo in ([[info ik_dictionaryForKey:kComments] ik_arrayForKey:kData])) {
            InstagramComment *comment = [[InstagramComment alloc] initWithInfo:commentInfo];
            [mComments addObject:comment];
        }
        if ([info ik_arrayForKey:kTags]) {
            _tags = [[NSArray alloc] initWithArray:[info ik_arrayForKey:kTags]];
        }
        
        NSDictionary *locationDictionary = [info ik_dictionaryForKey:kLocation];
        if ([locationDictionary ik_numberForKey:kLatitude] && [locationDictionary ik_numberForKey:kLongitude]) {
            _location = CLLocationCoordinate2DMake([[locationDictionary ik_numberForKey:kLatitude] doubleValue], [[locationDictionary ik_numberForKey:kLongitude] doubleValue]);
        }
        
        _filter = [info ik_stringForKey:kFilter];
        
        [self initializeImages:[info ik_dictionaryForKey:kImages]];
        
        NSString *mediaType = [info ik_stringForKey:kType];
        _isVideo = [mediaType isEqualToString:[NSString stringWithFormat:@"%@", kMediaTypeVideo]];
        if (_isVideo) {
            [self initializeVideos:[info ik_dictionaryForKey:kVideos]];
        }
    }
    return self;
}

- (void)initializeImages:(NSDictionary *)imagesInfo
{
    NSDictionary *thumbInfo = [imagesInfo ik_dictionaryForKey:kThumbnail];
    _thumbnailURL = [thumbInfo ik_urlForKey:kURL];
    if ([thumbInfo ik_numberForKey:kWidth] && [thumbInfo ik_numberForKey:kHeight]) {
        _thumbnailFrameSize = CGSizeMake([[thumbInfo ik_numberForKey:kWidth] floatValue], [[thumbInfo ik_numberForKey:kHeight] floatValue]);
    }
    
    NSDictionary *lowResInfo = [imagesInfo ik_dictionaryForKey:kLowResolution];
    _lowResolutionImageURL = [lowResInfo ik_urlForKey:kURL];
    if ([lowResInfo ik_numberForKey:kWidth] && [lowResInfo ik_numberForKey:kHeight]) {
        _lowResolutionImageFrameSize = CGSizeMake([[lowResInfo ik_numberForKey:kWidth] floatValue], [[lowResInfo ik_numberForKey:kHeight] floatValue]);
    }
    
    NSDictionary *standardResInfo = [imagesInfo ik_dictionaryForKey:kStandardResolution];
    _standardResolutionImageURL = [standardResInfo ik_urlForKey:kURL];
    if ([standardResInfo ik_numberForKey:kWidth] && [standardResInfo ik_numberForKey:kHeight]) {
        _standardResolutionImageFrameSize = CGSizeMake([[standardResInfo ik_numberForKey:kWidth] floatValue], [[standardResInfo ik_numberForKey:kHeight] floatValue]);
    }
}

- (void)initializeVideos:(NSDictionary *)videosInfo
{
    NSDictionary *lowResInfo = [videosInfo ik_dictionaryForKey:kLowResolution];
    _lowResolutionVideoURL = [lowResInfo ik_urlForKey:kURL];
    if ([lowResInfo ik_numberForKey:kWidth] && [lowResInfo ik_numberForKey:kHeight]) {
        _lowResolutionVideoFrameSize = CGSizeMake([[lowResInfo ik_numberForKey:kWidth] floatValue], [[lowResInfo ik_numberForKey:kHeight] floatValue]);
    }
    
    NSDictionary *standardResInfo = [videosInfo ik_dictionaryForKey:kStandardResolution];
    _standardResolutionVideoURL = [standardResInfo ik_urlForKey:kURL];
    if ([standardResInfo ik_numberForKey:kWidth] && [standardResInfo ik_numberForKey:kHeight]) {
        _standardResolutionVideoFrameSize = CGSizeMake([[standardResInfo ik_numberForKey:kWidth] floatValue], [[standardResInfo ik_numberForKey:kHeight] floatValue]);
    }
}

@end
