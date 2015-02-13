//
//  InstagramPaginationInfo.h
//  InstagramKitDemo
//
//  Created by Shyam Bhat on 06/03/14.
//  Copyright (c) 2014 Shyam Bhat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InstagramPaginationInfo : NSObject

@property (readonly) NSURL* nextURL;
@property (readonly) NSString* nextIdType;
@property (readonly) Class type;

-(NSString *)nextMaxId;
-(NSString *)nextCursor;

- (id)initWithInfo:(NSDictionary *)info andObjectType:(Class)type;

@end
