//
//  IGUser.h
//  InstaKit
//
//  Created by Shyam Bhat on 13/07/13.
//  Copyright (c) 2013 Shyam Bhat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InstagramUser : NSObject

@property (readonly) NSString* identifier;
@property (readonly) NSString* fullname;
@property (readonly) NSString* username;
@property (readonly) NSString* bio;
@property (readonly) NSString* website;
@property (readonly) NSString* profilePictureUrl;
@property (readonly) NSInteger followedByCount;
@property (readonly) NSInteger followersCount;
@property (readonly) NSInteger mediaCount;

@end
