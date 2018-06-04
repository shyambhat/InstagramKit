//
//    Copyright (c) 2018 Shyam Bhat
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy of
//    this software and associated documentation files (the "Software"), to deal in
//    the Software without restriction, including without limitation the rights to
//    use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//    the Software, and to permit persons to whom the Software is furnished to do so,
//    subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//    FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//    COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//    IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//    CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

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

