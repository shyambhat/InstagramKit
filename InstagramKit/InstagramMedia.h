//
//  IGMedia.h
//  InstagramKit
//
//  Created by Shyam Bhat on 13/07/13.
//  Copyright (c) 2013 Shyam Bhat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class InstagramUser;
@class InstagramComment;

@interface InstagramMedia : NSObject

@property (nonatomic, readonly) NSString* Id;
@property (nonatomic, readonly) InstagramUser* user;
@property (nonatomic, readonly) NSDate *createdDate;
@property (nonatomic, readonly) NSString* link;

@property (nonatomic, readonly) InstagramComment* caption;
@property (nonatomic, readonly) NSInteger likesCount;
@property (nonatomic, readonly) NSArray *likes;
@property (nonatomic, readonly) NSInteger commentCount;
@property (nonatomic, readonly) NSArray *comments;
@property (nonatomic, readonly) NSArray *tags;

@property (nonatomic, readonly) NSArray *imageInfos;
@property (nonatomic, readonly) CLLocationCoordinate2D location;

@property (nonatomic, readonly) NSString* filter;
@property (nonatomic, readonly) NSDictionary* images;

@property (nonatomic, readonly) BOOL isVideo;
@property (nonatomic, readonly) NSArray *videoInfos;

- (id)initWithInfo:(NSDictionary *)info;

@end
