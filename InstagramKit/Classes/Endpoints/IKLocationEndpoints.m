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

#import "IKLocationEndpoints.h"
#import "InstagramKit.h"

@implementation IKLocationEndpoints


- (void)searchLocationsAtLocation:(CLLocationCoordinate2D)location
                      withSuccess:(IKLocationsBlock)success
                          failure:(InstagramFailureBlock)failure
{
    [self getPaginatedPath:[NSString stringWithFormat:@"locations/search?lat=%f&lng=%f", location.latitude, location.longitude]
                parameters:nil
             responseModel:[IKLocation class]
                   success:success
                   failure:failure];
}


- (void)searchLocationsAtLocation:(CLLocationCoordinate2D)location
                 distanceInMeters:(NSInteger)distance
                      withSuccess:(IKLocationsBlock)success
                          failure:(InstagramFailureBlock)failure
{
    [self getPaginatedPath:[NSString stringWithFormat:@"locations/search?lat=%f&lng=%f&distance=%ld", location.latitude, location.longitude, (long)distance]
                parameters:nil
             responseModel:[IKLocation class]
                   success:success
                   failure:failure];
}


- (void)getLocationWithId:(NSString*)locationId
              withSuccess:(IKLocationBlock)success
                  failure:(InstagramFailureBlock)failure
{
    [self getPath:[NSString stringWithFormat:@"locations/%@", locationId]
    responseModel:[IKLocation class]
          success:success
          failure:failure];
}


@end
