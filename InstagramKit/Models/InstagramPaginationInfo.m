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
    BOOL infoExists = ik_dictionaryIsValid(info) && ik_stringIsValid(info[kNextURL]);
    if (self && infoExists){
        
        _nextURL = [[NSURL alloc] initWithString:ik_safeString(info[kNextURL])];
        BOOL nextMaxIdExists = ik_stringIsValid(info[kNextMaxId]);
        BOOL nextMaxLikeIdExists = ik_stringIsValid(info[kNextMaxLikeId]);
        BOOL nextCursorExists = ik_stringIsValid(info[kNextCursor]);
        if (nextMaxIdExists)
        {
            _nextMaxId = [[NSString alloc] initWithString:ik_safeString(info[kNextMaxId])];
        }
        else if (nextMaxLikeIdExists)
        {
            _nextMaxId = [[NSString alloc] initWithString:ik_safeString(info[kNextMaxLikeId])];
        }
        else if (nextCursorExists)
        {
            _nextMaxId = [[NSString alloc] initWithString:ik_safeString(info[kNextCursor])];
        }
        
        if (type) {
            self.type = type;
        }
        return self;
    }
    return nil;
}

@end
