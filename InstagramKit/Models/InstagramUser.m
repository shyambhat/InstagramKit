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
#import "NSDictionary+IKValidation.h"

@interface InstagramUser()
@property (nonatomic, strong) NSArray *recentMedia;
@end

@implementation InstagramUser

- (id)initWithInfo:(NSDictionary *)info
{
    self = [super initWithInfo:info];
    if (self && [info isKindOfClass:[NSDictionary class]]) {
        _username = [info ik_stringForKey:kUsername];
        _fullName = [info ik_stringForKey:kFullName];
        _profilePictureURL = [info ik_urlForKey:kProfilePictureURL];
        _bio = [info ik_stringForKey:kBio];
        _website = [info ik_urlForKey:kWebsite];

        // DO NOT PERSIST
        NSDictionary *countsDictionary = [info ik_dictionaryForKey:kCounts];
        _mediaCount = [[countsDictionary ik_numberForKey:kCountMedia] integerValue];
        _followsCount = [[countsDictionary ik_numberForKey:kCountFollows] integerValue];
        _followedByCount = [[countsDictionary ik_numberForKey:kCountFollowedBy] integerValue];
    }
    return self;
}

- (void)loadUserDetails
{
    [self loadUserDetailsWithSuccess:nil failure:nil];
}

- (void)loadUserDetailsWithSuccess:(void(^)(void))success failure:(void(^)(void))failure
{
    [[InstagramEngine sharedEngine] getUserDetails:self.Id withSuccess:^(InstagramUser *userDetail) {
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
