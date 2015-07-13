//
//  InstagramPaginationInfo.m
//  InstagramKitDemo
//
//  Created by Shyam Bhat on 06/03/14.
//  Copyright (c) 2014 Shyam Bhat. All rights reserved.
//

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
            _nextMaxId = kNextMaxId;
        }
        else if (nextMaxLikeIdExists)
        {
            _nextMaxId = kNextMaxLikeId;
        }
        else if (nextCursorExists)
        {
            _nextMaxId = kNextCursor;
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
