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


#import "InstagramTag.h"
#import "InstagramModel.h"

@implementation InstagramTag

- (instancetype)initWithInfo:(NSDictionary *)info
{
    self = [super init];
    if (self && IKNotNull(info)) {
        _name = [[NSString alloc] initWithString:info[kTagName]];
        _mediaCount = [info[kTagMediaCount] integerValue];
    }
    return self;
}

#pragma mark - Equality

- (BOOL)isEqualToTag:(InstagramTag *)tag {
    if (self == tag) {
        return YES;
    }
    if (tag && [tag respondsToSelector:@selector(name)]) {
        return [_name isEqualToString:tag.name];
    }
    return NO;
}

#pragma mark - NSCoding

+ (BOOL)supportsSecureCoding
{
    return YES;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [self init])) {
        _name = [decoder decodeObjectOfClass:[NSString class] forKey:kTagName];
        _mediaCount = [decoder decodeIntegerForKey:kTagMediaCount];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_name forKey:kTagName];
    [encoder encodeInteger:_mediaCount forKey:kTagMediaCount];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    InstagramTag *copy = [[InstagramTag allocWithZone:zone] init];
    copy->_name = [_name copy];
    copy->_mediaCount = _mediaCount;
    return copy;
}


@end
