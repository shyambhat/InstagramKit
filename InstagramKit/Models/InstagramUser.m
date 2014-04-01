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

#import "InstagramUser.h"
#import "InstagramEngine.h"

@interface InstagramUser()
@property (nonatomic, strong) NSArray *recentMedia;
@end

@implementation InstagramUser

- (id)initWithInfo:(NSDictionary *)info
{
    self = [super initWithInfo:info];
    if (self && IKNotNull(info)) {
        _username = [[NSString alloc] initWithString:info[kUsername]];
        _fullName = [[NSString alloc] initWithString:info[kFullName]];
        _profilePictureURL = [[NSURL alloc] initWithString:info[kProfilePictureURL]];
        if (IKNotNull(info[kBio]))
            _bio = [[NSString alloc] initWithString:info[kBio]];;
        if (IKNotNull(info[kWebsite]))
            _website = [[NSURL alloc] initWithString:info[kWebsite]];

        // DO NOT PERSIST
        if (IKNotNull(info[kCounts]))
        {
            _mediaCount = [(info[kCounts])[kCountMedia] integerValue];
            _followsCount = [(info[kCounts])[kCountFollows] integerValue];
            _followedByCount = [(info[kCounts])[kCountFollowedBy] integerValue];
        }
    }
    return self;
}

- (void)loadCounts
{
    [self loadCountsWithSuccess:nil failure:nil];
}

- (void)loadCountsWithSuccess:(void(^)(void))success failure:(void(^)(void))failure
{
    [[InstagramEngine sharedEngine] getUserDetails:self withSuccess:^(InstagramUser *userDetail) {
        _mediaCount = userDetail.mediaCount;
        _followsCount = userDetail.followsCount;
        _followedByCount = userDetail.followedByCount;
        success();
    } failure:^(NSError *error) {
        failure();
    }];
}

- (void)loadRecentMedia:(NSInteger)count
{
    [self loadRecentMedia:count withSuccess:nil failure:nil];
}

- (void)loadRecentMedia:(NSInteger)count withSuccess:(void(^)(void))success failure:(void(^)(void))failure
{
    [[InstagramEngine sharedEngine] getMediaForUser:self.Id withSuccess:^(NSArray *media, InstagramPaginationInfo *paginationInfo) {
        self.recentMedia = media;
        success();
    } failure:^(NSError *error) {
        failure();
    }];
}

@end
