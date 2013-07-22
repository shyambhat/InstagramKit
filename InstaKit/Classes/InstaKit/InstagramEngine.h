//
//  InstaKit.h
//  InstaKit
//
//  Created by Shyam Bhat on 13/07/13.
//  Copyright (c) 2013 Shyam Bhat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

@interface InstagramEngine : AFHTTPClient

- (void)presentAuthenticationDialog;
@end
