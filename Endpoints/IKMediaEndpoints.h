//
//  IKMediaEndpoints.h
//  InstagramKit
//
//  Created by Shyam Bhat on 6/4/18.
//

#import "IKEndpointsBase.h"
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IKMediaEndpoints : IKEndpointsBase


/**
 *  Get information about a Media object.
 *
 *  @param mediaId  Id of a Media object.
 *  @param success  Provides a fully populated Media object.
 *  @param failure  Provides an error and a server status code.
 */
- (void)getMedia:(NSString *)mediaId
     withSuccess:(InstagramMediaObjectBlock)success
         failure:(nullable InstagramFailureBlock)failure;


/**
 *  Search for media in a given area. The default time span is set to 5 days.
 *  Can return mix of image and video types.
 *
 *  @param location Geographic Location coordinates.
 *  @param success  Provides an array of Media objects and Pagination info.
 *  @param failure  Provides an error and a server status code.
 */
- (void)getMediaAtLocation:(CLLocationCoordinate2D)location
               withSuccess:(InstagramMediaBlock)success
                   failure:(nullable InstagramFailureBlock)failure;

/**
 *  Search for media in a given area. The default time span is set to 5 days.
 *  Can return mix of image and video types.
 *
 *  @param location Geographic Location coordinates.
 *  @param count    Count of objects to fetch.
 *  @param maxId    The nextMaxId from the previously obtained PaginationInfo object.
 *  @param distance Distance in metres to from location - max 5000 (5km), default is 1000 (1km) in other methods
 *  @param success  Provides an array of Media objects and Pagination info.
 *  @param failure  Provides an error and a server status code.
 */
- (void)getMediaAtLocation:(CLLocationCoordinate2D)location
                     count:(NSInteger)count
                     maxId:(nullable NSString *)maxId
                  distance:(CGFloat)distance
               withSuccess:(InstagramMediaBlock)success
                   failure:(nullable InstagramFailureBlock)failure;

/**
 *  Get a list of recent media objects from a given location.
 *
 *  @param locationId   Id of a Location object.
 *  @param success      Provides an array of Media objects and Pagination info.
 *  @param failure      Provides an error and a server status code.
 */
- (void)getMediaAtLocationWithId:(NSString*)locationId
                     withSuccess:(InstagramMediaBlock)success
                         failure:(nullable InstagramFailureBlock)failure;


@end

NS_ASSUME_NONNULL_END

