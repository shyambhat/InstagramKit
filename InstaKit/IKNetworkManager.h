//
//  IKNetworkManager.h
//  InstaKit
//
//  Created by Shyam Bhat on 23/07/13.
//  Copyright (c) 2013 Shyam Bhat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

@interface IKNetworkManager : AFHTTPClient

- (void)requestPopularMediaWithSuccess:(void (^)(NSArray *mediaInfo))success failure:(void (^)(NSError *error))failure;

@end
