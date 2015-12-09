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

#import "InstagramUser.h"
#import "InstagramEngine.h"

@interface InstagramUser()

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *fullName;
@property (nonatomic, strong) NSURL *profilePictureURL;
@property (nonatomic, copy) NSString *bio;
@property (nonatomic, strong) NSURL *website;
@property (nonatomic, assign) NSInteger mediaCount;
@property (nonatomic, assign) NSInteger followsCount;
@property (nonatomic, assign) NSInteger followedByCount;

@end

@implementation InstagramUser

- (instancetype)initWithInfo:(NSDictionary *)info
{
    self = [super initWithInfo:info];
    if (self && IKNotNull(info)) {
        [self updateDetailsWithInfo:info];
    }
    return self;
}

- (void)updateDetailsWithInfo:(NSDictionary *)info
{
    self.username = [[NSString alloc] initWithString:info[kUsername]];
    self.fullName = [[NSString alloc] initWithString:info[kFullName]];
    
    self.profilePictureURL = (IKNotNull(info[kProfilePictureURL])) ? [[NSURL alloc] initWithString:info[kProfilePictureURL]] : nil;
    self.bio = (IKNotNull(info[kBio])) ? [[NSString alloc] initWithString:info[kBio]] : nil;
    self.website = (IKNotNull(info[kWebsite])) ? [[NSURL alloc] initWithString:info[kWebsite]] : nil;
    
    if (IKNotNull(info[kCounts]))
    {
        self.mediaCount = [(info[kCounts])[kCountMedia] integerValue];
        self.followsCount = [(info[kCounts])[kCountFollows] integerValue];
        self.followedByCount = [(info[kCounts])[kCountFollowedBy] integerValue];
    }
}

- (void)updateDetailsWithUser:(InstagramUser *)user
{
    self.username = user.username;
    self.fullName = user.fullName;
    self.profilePictureURL = user.profilePictureURL;
    self.bio = user.bio;
    self.website = user.website;
    self.mediaCount = user.mediaCount;
    self.followsCount = user.followsCount;
    self.followedByCount = user.followedByCount;
}


- (void)loadDetailsWithCompletion:(void (^)())success
                          failure:(nullable InstagramFailureBlock)failure
{
    [[InstagramEngine sharedEngine] getUserDetails:self.Id
                                       withSuccess:^(InstagramUser * _Nonnull userDetail) {
                                           [self updateDetailsWithUser:userDetail];
                                           success();
                                       } failure:failure];
}

#pragma mark - Equality

- (BOOL)isEqualToUser:(InstagramUser *)user {
    return [super isEqualToModel:user];
}

#pragma mark - NSCoding

+ (BOOL)supportsSecureCoding
{
    return YES;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super initWithCoder:decoder])) {
        self.username = [decoder decodeObjectOfClass:[NSString class] forKey:kUsername];
        self.fullName = [decoder decodeObjectOfClass:[NSString class] forKey:kFullName];
        self.profilePictureURL = [decoder decodeObjectOfClass:[NSString class] forKey:kProfilePictureURL];
        self.bio = [decoder decodeObjectOfClass:[NSString class] forKey:kBio];
        self.website = [decoder decodeObjectOfClass:[NSString class] forKey:kWebsite];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];

    [encoder encodeObject:self.username forKey:kUsername];
    [encoder encodeObject:self.fullName forKey:kFullName];
    [encoder encodeObject:self.profilePictureURL forKey:kProfilePictureURL];
    [encoder encodeObject:self.bio forKey:kBio];
    [encoder encodeObject:self.website forKey:kWebsite];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    InstagramUser *copy = [super copyWithZone:zone];
    copy->_username = [self.username copy];
    copy->_fullName = [self.fullName copy];
    copy->_profilePictureURL = [self.profilePictureURL copy];
    copy->_bio = [self.bio copy];
    copy->_website = [self.website copy];
    return copy;
}

@end
