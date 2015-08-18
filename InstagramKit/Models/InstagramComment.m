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

#import "InstagramComment.h"
#import "InstagramUser.h"

@implementation InstagramComment

- (instancetype)initWithInfo:(NSDictionary *)info
{
    self = [super initWithInfo:info];
    if (self && IKNotNull(info)) {
        _user = [[InstagramUser alloc] initWithInfo:info[kCreator]];
        _text = [[NSString alloc] initWithString:info[kText]];
        _createdDate = [[NSDate alloc] initWithTimeIntervalSince1970:[info[kCreatedDate] doubleValue]];
    }
    return self;
}

#pragma mark - Equality

- (BOOL)isEqualToComment:(InstagramComment *)comment {
    return [super isEqualToModel:comment];
}

#pragma mark - NSCoding

+ (BOOL)supportsSecureCoding
{
    return YES;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super initWithCoder:decoder])) {
        _user = [decoder decodeObjectOfClass:[InstagramUser class] forKey:kCreator];
        _text = [decoder decodeObjectOfClass:[NSString class] forKey:kText];
        _createdDate = [decoder decodeObjectOfClass:[NSDate class] forKey:kCreatedDate];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];

    [encoder encodeObject:_user forKey:kCreator];
    [encoder encodeObject:_text forKey:kText];
    [encoder encodeObject:_createdDate forKey:kCreatedDate];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    InstagramComment *copy = [super copyWithZone:zone];
    copy->_user = [_user copy];
    copy->_text = [_text copy];
    copy->_createdDate = [_createdDate copy];
    return copy;
}

@end
