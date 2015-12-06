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

#import "UserInPhoto.h"
#import "InstagramModel.h"
#import "InstagramUser.h"

@interface UserInPhoto ()

@property (nonatomic, strong) InstagramUser *user;
@property (nonatomic, assign) CGPoint position;

@end

@implementation UserInPhoto

- (id)initWithInfo:(NSDictionary *)info
{
    self = [super initWithInfo:info];
    if (self && IKNotNull(info)) {

        NSDictionary *positionInfo = info[kPosition];
        CGPoint position;
        position.x = [positionInfo[kX] floatValue];
        position.y = [info[kY] floatValue];
        self.position = position;
        self.user =  [[InstagramUser alloc] initWithInfo:info[kUser]];
    }
    return self;
}

#pragma mark - Equality

- (BOOL)isEqualToUserInPhoto:(UserInPhoto *)userInPhoto {
    return [self.user isEqualToUser:userInPhoto.user]
    && self.position.x == userInPhoto.position.x
    && self.position.y == userInPhoto.position.y;
}

#pragma mark - NSCoding

+ (BOOL)supportsSecureCoding
{
    return YES;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super initWithCoder:decoder])) {
        CGPoint position;
        position.x = [decoder decodeDoubleForKey:kX];
        position.y = [decoder decodeDoubleForKey:kY];
        self.position = position;
        self.user = [decoder decodeObjectOfClass:[NSString class] forKey:kLocationName];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];

    [encoder encodeDouble:self.position.x forKey:kX];
    [encoder encodeDouble:self.position.y forKey:kY];
    [encoder encodeObject:self.user forKey:kUser];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    UserInPhoto *copy = [super copyWithZone:zone];
    copy->_position = self.position;
    copy->_user = [self.user copy];
    return copy;
}

@end
