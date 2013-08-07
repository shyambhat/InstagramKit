//
//  IGUser.h
//  InstagramKit
//
//  Created by Shyam Bhat on 13/07/13.
//  Copyright (c) 2013 Shyam Bhat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InstagramUser : NSObject

@property (readonly) NSString* Id;
@property (readonly) NSString* username;
@property (readonly) NSString* fullname;
@property (readonly) NSString* profilePicture;
@property (readonly) NSString* bio;
@property (readonly) NSURL* website;

- (id)initWithInfo:(NSDictionary *)info;

@end
