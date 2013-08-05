//
//  IGMedia.h
//  InstagramKit
//
//  Created by Shyam Bhat on 13/07/13.
//  Copyright (c) 2013 Shyam Bhat. All rights reserved.
//

#import <Foundation/Foundation.h>

@class InstagramUser;

@interface InstagramMedia : NSObject

@property (readonly) NSString* identifier;
@property (strong) NSString* linkUrl; //temporarily strong
@property (strong) NSString* caption;
@property (readonly) NSInteger commentCount;
@property (readonly) NSInteger likeCount;
@property (readonly) NSString* filter;
@property (readonly) InstagramUser* user;
@property (readonly) NSString* locationIdentifier;
@property (readonly) NSString* locationLatitude;
@property (readonly) NSString* locationLongitude;
@property (readonly) NSString* locationName;
@property (readonly) NSDate* createdTime;
@property (readonly) NSDictionary* images;
@property (readonly) CGSize *mediaFrameSize;

- (id)initWithInfo:(NSDictionary *)info;

@end
