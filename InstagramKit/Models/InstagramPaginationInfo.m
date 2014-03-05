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
    if (self && IKNotNull(info)) {
        _nextURL = [[NSURL alloc] initWithString:info[kNextURL]];
        _nextMaxId = [[NSString alloc] initWithString:info[kNextMaxId]];
    }
    return self;
}

@end
