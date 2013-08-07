//
//  IGComment.h
//  InstagramKit
//
//  Created by Shyam Bhat on 13/07/13.
//  Copyright (c) 2013 Shyam Bhat. All rights reserved.
//

#import <Foundation/Foundation.h>

@class InstagramUser;

@interface InstagramComment : NSObject

@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSDate *createdDate;
@property (nonatomic, strong) InstagramUser *creator;
@property (nonatomic, strong) NSString *text;

- (id)initWithInfo:(NSDictionary *)info;

@end