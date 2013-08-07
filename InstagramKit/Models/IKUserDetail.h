//
//  IKUserDetail.h
//  Cypress
//
//  Created by Shyam Bhat on 07/08/13.
//  Copyright (c) 2013 Shyam Bhat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IKUserDetail : NSObject

@property (readonly) NSInteger followedByCount;
@property (readonly) NSInteger followersCount;
@property (readonly) NSInteger mediaCount;

- (id)initWithInfo:(NSDictionary *)info;

@end
