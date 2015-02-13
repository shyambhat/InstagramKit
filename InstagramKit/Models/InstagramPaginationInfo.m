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
@property (readonly) NSString* nextId;
@end

@implementation InstagramPaginationInfo

- (id)initWithInfo:(NSDictionary *)info andObjectType:(Class)type
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
            _nextId = [[NSString alloc] initWithString:info[kNextMaxId]];
            _nextIdType = kMaxId;
        }
        else if (nextMaxLikeIdExists)
        {
            _nextId = [[NSString alloc] initWithString:info[kNextMaxLikeId]];
            _nextIdType = kMaxId;
        }
        else if (nextCursorExists)
        {
            _nextId = [[NSString alloc] initWithString:info[kNextCursor]];
            _nextIdType = kCursor;
        }
        
        if (type) {
            self.type = type;
        }
        return self;
    }
    return nil;
}

-(NSString *)nextMaxId
{
    if([_nextIdType isEqual:kMaxId])
        return _nextId;
    return nil;
}
-(NSString *)nextCursor
{
    if([_nextIdType isEqual:kCursor])
        return _nextId;
    return nil;
}


@end
