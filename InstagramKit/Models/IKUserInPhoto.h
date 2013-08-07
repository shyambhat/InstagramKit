//
//  IKUserInPhoto.h
//  Cypress
//
//  Created by Shyam Bhat on 07/08/13.
//  Copyright (c) 2013 Shyam Bhat. All rights reserved.
//

#import <Foundation/Foundation.h>

@class InstagramUser;

@interface IKUserInPhoto : NSObject

@property (nonatomic, readonly) CGPoint positionPercentage;
@property (nonatomic, readonly) InstagramUser *user;

- (id)initWithInfo:(NSDictionary *)info;

@end
