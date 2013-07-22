//
//  InstaKit.m
//  InstaKit
//
//  Created by Shyam Bhat on 13/07/13.
//  Copyright (c) 2013 Shyam Bhat. All rights reserved.
//

#import "InstagramEngine.h"
#import "InstagramUser.h"

@implementation InstagramEngine
#pragma mark - Singleton -

+ (InstagramEngine *)sharedEngine
{
    static InstagramEngine *_sharedEngine = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedEngine = [[self alloc] init];
    });    
    return _sharedEngine;
}

#pragma mark - Authentication -

- (void)presentAuthenticationDialog
{
    
}


#pragma mark - Users -


@end
    