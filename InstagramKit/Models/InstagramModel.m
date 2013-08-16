//
//  InstagramModel.m
//  Cypress
//
//  Created by Shyam Bhat on 16/08/13.
//  Copyright (c) 2013 Shyam Bhat. All rights reserved.
//

#import "InstagramModel.h"

@implementation InstagramModel

- (id)initWithInfo:(NSDictionary *)info
{
    self = [super init];
    if (self && VALID_OBJECT(info)) {
        _Id = [[NSString alloc] initWithString:info[kID]];
    }
    return self;
}

@end
