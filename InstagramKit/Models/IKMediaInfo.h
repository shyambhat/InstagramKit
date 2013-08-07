//
//  IKMediaInfo.h
//  Cypress
//
//  Created by Shyam Bhat on 07/08/13.
//  Copyright (c) 2013 Shyam Bhat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IKMediaInfo : NSObject
@property (nonatomic, readonly) NSString *description;
@property (nonatomic, readonly) NSURL *url;
@property (nonatomic, readonly) CGSize *frame;

- (id)initWithInfo:(NSDictionary *)info;

@end
