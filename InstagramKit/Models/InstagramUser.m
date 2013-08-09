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
#define kID @"id"
#define kUsername @"username"
#define kFullName @"full_name"
#define kProfilePictureURL @"profile_picture"
#define kBio @"bio"
#define kWebsite @"website"

#define VALID_OBJECT(obj) (obj && ![obj isEqual:[NSNull null]])

@implementation InstagramUser

- (id)initWithInfo:(NSDictionary *)info
{
    self = [super init];
    if (self && VALID_OBJECT(info)) {
        _Id = [[NSString alloc] initWithString:info[kID]];
        _username = [[NSString alloc] initWithString:info[kUsername]];
        _fullname = [[NSString alloc] initWithString:info[kFullName]];
        _profilePictureURL = [[NSURL alloc] initWithString:info[kProfilePictureURL]];
        if (VALID_OBJECT(info[kBio]))
            _bio = [[NSString alloc] initWithString:info[kBio]];;
        
        if (VALID_OBJECT(info[kWebsite]))
            _website = [[NSURL alloc] initWithString:info[kWebsite]];
        
    }
    return self;
}


@end
