//
//  InstagramPaginationInfo.h
//  InstagramKitDemo
//
//  Created by Shyam Bhat on 06/03/14.
//  Copyright (c) 2014 Shyam Bhat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InstagramPaginationInfo : NSObject <NSCopying, NSSecureCoding, NSObject>

/**
 *  URL to receive next set of paginated items.
 */
@property (readonly) NSURL* nextURL;

/**
 *  Offset from which the next paginated Media is to be received.
 */
@property (readonly) NSString *nextMaxId;

/**
 *  Class of Objects which are being paginated.
 */
@property (readonly) Class type;

/**
 *  Initializes a new InstagramPaginationInfo object.
 *
 *  @param info Received JSON dictionary.
 *  @param type Class of Objects which are being paginated.
 */
- (instancetype)initWithInfo:(NSDictionary *)info andObjectType:(Class)type;

/**
 *  Comparing InstagramPaginationInfo objects.
 *  @param paginationInfo   An InstagramPaginationInfo object.
 *  @return                 YES is nextURLs match. Else NO.
 */
- (BOOL)isEqualToPaginationInfo:(InstagramPaginationInfo *)paginationInfo;

@end
