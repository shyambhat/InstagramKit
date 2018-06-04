//
//  InstagramLocationEndpoints.h
//  InstagramKit
//
//  Created by Shyam Bhat on 6/4/18.
//

#import "IKEndpointsBase.h"
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface InstagramLocationEndpoints : IKEndpointsBase


/**
 *  Search for a location by geographic coordinate.
 *
 *  @param location Geographic Location coordinates.
 *  @param success  Provides an array of Location objects.
 *  @param failure  Provides an error and a server status code.
 */
- (void)searchLocationsAtLocation:(CLLocationCoordinate2D)location
                      withSuccess:(InstagramLocationsBlock)success
                          failure:(nullable InstagramFailureBlock)failure;


/**
 *  Search for a location by geographic coordinate.
 *
 *  @param location         Geographic Location coordinates.
 *  @param distanceInMeters Default is 1000, max distance is 5000.
 *  @param success          Provides an array of Location objects.
 *  @param failure          Provides an error and a server status code.
 */
- (void)searchLocationsAtLocation:(CLLocationCoordinate2D)location
                 distanceInMeters:(NSInteger)distanceInMeters
                      withSuccess:(InstagramLocationsBlock)success
                          failure:(nullable InstagramFailureBlock)failure;


/**
 *  Get information about a Location.
 *
 *  @param locationId   Id of a Location object.
 *  @param success      Provides a Location object.
 *  @param failure      Provides an error and a server status code.
 */
- (void)getLocationWithId:(NSString*)locationId
              withSuccess:(InstagramLocationBlock)success
                  failure:(nullable InstagramFailureBlock)failure;


@end

NS_ASSUME_NONNULL_END

