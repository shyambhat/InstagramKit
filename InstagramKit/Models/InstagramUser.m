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

@implementation InstagramUser

- (instancetype)initWithInfo:(NSDictionary *)info
{
    self = [super initWithInfo:info];
    if (self && ik_dictionaryIsValid(info)) {
        [self updateDetails:info];
    }
    return self;
}


- (void)updateDetails:(NSDictionary *)info
{
    _username = [[NSString alloc] initWithString:ik_safeString(info[kUsername])];
    _fullName = [[NSString alloc] initWithString:ik_safeString(info[kFullName])];
    _profilePictureURL = [[NSURL alloc] initWithString:ik_safeString(info[kProfilePictureURL])];
    _bio = [[NSString alloc] initWithString:ik_safeString(info[kBio])];;
    _website = [[NSURL alloc] initWithString:ik_safeString(info[kWebsite])];
    
    // DO NOT PERSIST
    if (ik_dictionaryIsValid(info[kCounts]))
    {
        _mediaCount = [ik_safeNumber((info[kCounts])[kCountMedia]) integerValue];
        _followsCount = [ik_safeNumber((info[kCounts])[kCountFollows]) integerValue];
        _followedByCount = [ik_safeNumber((info[kCounts])[kCountFollowedBy]) integerValue];
    }
}


- (BOOL)isEqualToUser:(InstagramUser *)user {
    return [super isEqualToModel:user];
}
@end
