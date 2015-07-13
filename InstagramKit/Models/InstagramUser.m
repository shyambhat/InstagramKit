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

@implementation InstagramUser

- (instancetype)initWithInfo:(NSDictionary *)info
{
    self = [super initWithInfo:info];
    if (self && IKNotNull(info)) {
        [self updateDetails:info];
    }
    return self;
}

- (void)updateDetails:(NSDictionary *)info
{
    _username = [[NSString alloc] initWithString:info[kUsername]];
    _fullName = [[NSString alloc] initWithString:info[kFullName]];
    
    if (IKNotNull(info[kProfilePictureURL]))
    {
        _profilePictureURL = [[NSURL alloc] initWithString:info[kProfilePictureURL]];
    }
    
    if (IKNotNull(info[kBio]))
    {
        _bio = [[NSString alloc] initWithString:info[kBio]];
    }
    
    if (IKNotNull(info[kWebsite]))
    {
        _website = [[NSURL alloc] initWithString:info[kWebsite]];
    }
    
    if (IKNotNull(info[kCounts]))
    {
        _mediaCount = [(info[kCounts])[kCountMedia] integerValue];
        _followsCount = [(info[kCounts])[kCountFollows] integerValue];
        _followedByCount = [(info[kCounts])[kCountFollowedBy] integerValue];
    }
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
    if ((self = [self init])) {
        _username = [decoder decodeObjectOfClass:[NSString class] forKey:kUsername];
        _fullName = [decoder decodeObjectOfClass:[NSString class] forKey:kFullName];
        _profilePictureURL = [decoder decodeObjectOfClass:[NSString class] forKey:kProfilePictureURL];
        _bio = [decoder decodeObjectOfClass:[NSString class] forKey:kBio];
        _website = [decoder decodeObjectOfClass:[NSString class] forKey:kWebsite];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_username forKey:kUsername];
    [encoder encodeObject:_fullName forKey:kFullName];
    [encoder encodeObject:_profilePictureURL forKey:kProfilePictureURL];
    [encoder encodeObject:_bio forKey:kBio];
    [encoder encodeObject:_website forKey:kWebsite];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    InstagramUser *copy = [super copyWithZone:zone];
    copy->_username = [_username copy];
    copy->_fullName = [_fullName copy];
    copy->_profilePictureURL = [_profilePictureURL copy];
    copy->_bio = [_bio copy];
    copy->_website = [_website copy];
    return copy;
}

@end
