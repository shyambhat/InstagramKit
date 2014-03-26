//
//  InstagramPaginationInfo.m
//  InstagramKitDemo
//
//  Created by Shyam Bhat on 06/03/14.
//  Copyright (c) 2014 Shyam Bhat. All rights reserved.
//

#import "InstagramPaginationInfo.h"
#import "InstagramModel.h"

@implementation InstagramPaginationInfo

- (id)initWithInfo:(NSDictionary *)info
{
    self = [super init];
    BOOL infoExists = IKNotNull(info);
    BOOL nextURLExists = IKNotNull(info[kNextURL]);
    BOOL nextMaxIdExists = IKNotNull(info[kNextMaxId]);
    BOOL nextMaxLikeIdExists = IKNotNull(info[kNextMaxLikeId]);
    
    if (self && infoExists && nextURLExists && (nextMaxIdExists || nextMaxLikeIdExists) ){
        _nextURL = [[NSURL alloc] initWithString:info[kNextURL]];
        if (nextMaxIdExists)
        {
            _nextMaxId = [[NSString alloc] initWithString:info[kNextMaxId]];
        }
        else if (nextMaxLikeIdExists)
        {
            _nextMaxId = [[NSString alloc] initWithString:info[kNextMaxLikeId]];
        }
        return self;
    }
    return nil;
}

@end
