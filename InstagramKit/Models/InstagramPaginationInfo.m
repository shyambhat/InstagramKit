//
//  InstagramPaginationInfo.m
//  InstagramKitDemo
//
//  Created by Shyam Bhat on 06/03/14.
//  Copyright (c) 2014 Shyam Bhat. All rights reserved.
//

#import "InstagramPaginationInfo.h"
#import "InstagramModel.h"
#import "NSDictionary+IKValidation.h"

@interface InstagramPaginationInfo ()
@property (nonatomic, strong) Class type;
@end

@implementation InstagramPaginationInfo

- (id)initWithInfo:(NSDictionary *)info andObjectType:(Class)type
{
    self = [super init];
    BOOL infoExists = [info isKindOfClass:[NSDictionary class]] && [info ik_urlForKey:kNextURL];
    if (self && infoExists) {
        
        _nextURL = [info ik_urlForKey:kNextURL];
        _nextMaxId = [info ik_stringForKey:kNextMaxId];
        if (!_nextMaxId) {
            _nextMaxId = [info ik_stringForKey:kNextMaxLikeId];
        }
        
        if (type) {
            self.type = type;
        }
        return self;
    }
    return nil;
}

@end
