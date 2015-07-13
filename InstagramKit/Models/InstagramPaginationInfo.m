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

#import "InstagramPaginationInfo.h"
#import "InstagramModel.h"

@interface InstagramPaginationInfo ()
@property (nonatomic, strong) Class type;
@end

@implementation InstagramPaginationInfo

- (instancetype)initWithInfo:(NSDictionary *)info andObjectType:(Class)type
{
    self = [super init];
    BOOL infoExists = IKNotNull(info) && IKNotNull(info[kNextURL]);
    if (self && infoExists){
        
        _nextURL = [[NSURL alloc] initWithString:info[kNextURL]];
        BOOL nextMaxIdExists = IKNotNull(info[kNextMaxId]);
        BOOL nextMaxLikeIdExists = IKNotNull(info[kNextMaxLikeId]);
        BOOL nextCursorExists = IKNotNull(info[kNextCursor]);
        if (nextMaxIdExists)
        {
            _nextMaxId = [[NSString alloc] initWithString:info[kNextMaxId]];
        }
        else if (nextMaxLikeIdExists)
        {
            _nextMaxId = [[NSString alloc] initWithString:info[kNextMaxLikeId]];
        }
        else if (nextCursorExists)
        {
            _nextMaxId = [[NSString alloc] initWithString:info[kNextCursor]];
        }
        
        if (type) {
            self.type = type;
        }
        return self;
    }
    return nil;
}

#pragma mark - Equality

- (BOOL)isEqualToPaginationInfo:(InstagramPaginationInfo *)paginationInfo {
    
    if (self == paginationInfo) {
        return YES;
    }
    if (paginationInfo && [paginationInfo respondsToSelector:@selector(nextURL)]) {
        return [_nextURL.path isEqualToString:paginationInfo.nextURL.path];
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
        _nextURL = [decoder decodeObjectOfClass:[NSURL class] forKey:kNextURL];
        _nextMaxId = [decoder decodeObjectOfClass:[NSString class] forKey:kNextMaxId];
        _type = NSClassFromString([decoder decodeObjectOfClass:[NSString class] forKey:@"classType"]);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_nextURL forKey:kNextURL];
    [encoder encodeObject:_nextMaxId forKey:kNextMaxId];
    [encoder encodeObject:NSStringFromClass(_type) forKey:@"classType"];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    InstagramPaginationInfo *copy = [[InstagramPaginationInfo allocWithZone:zone] init];
    copy->_nextURL = [_nextURL copy];
    copy->_nextMaxId = [_nextMaxId copy];
    copy->_type = [_type copy];
    return copy;
}


@end
