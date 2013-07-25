//
//  InstaKit.m
//  InstaKit
//
//  Created by Shyam Bhat on 13/07/13.
//  Copyright (c) 2013 Shyam Bhat. All rights reserved.
//

#import "InstagramEngine.h"
#import "IKNetworkManager.h"
#import "IKConstants.h"
#import "InstagramUser.h"
#import "InstagramMedia.h"

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


#pragma mark - Explore -

- (void)requestPopularMediaWithSuccess:(void (^)(NSArray *media))success failure:(void (^)(NSError *error))failure
{
    IKNetworkManager *client = [IKNetworkManager clientWithBaseURL:[NSURL URLWithString:kInstagramAPIBaseURL]];
    [client requestPopularMediaWithSuccess:^(NSArray *mediaInfo) {
        NSMutableArray*objects = [NSMutableArray arrayWithCapacity:mediaInfo.count];
        for (NSDictionary *info in mediaInfo) {
            InstagramMedia *media = [[InstagramMedia alloc] initWithInfo:info];
            [objects addObject:media];
        }
        NSArray *mediaArray = [NSArray arrayWithArray:objects];
        success(mediaArray);
    } failure:^(NSError *error) {
        NSLog(@"Error : %@",error.description);
        failure(error);
    }];
}

@end
    