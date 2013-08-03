//
//  InstaKit.h
//  InstaKit
//
//  Created by Shyam Bhat on 13/07/13.
//  Copyright (c) 2013 Shyam Bhat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface InstagramEngine : AFHTTPClient

+ (InstagramEngine *)sharedEngine;
- (void)presentAuthenticationDialog;


- (void)requestPopularMediaWithSuccess:(void (^)(NSArray *media))success failure:(void (^)(NSError *error))failure;


@end
