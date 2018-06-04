//
//  InstagramLocationEndpoints.m
//  InstagramKit
//
//  Created by Shyam Bhat on 6/4/18.
//

#import "InstagramLocationEndpoints.h"
#import "InstagramKit.h"

@implementation InstagramLocationEndpoints


- (void)searchLocationsAtLocation:(CLLocationCoordinate2D)location
                      withSuccess:(InstagramLocationsBlock)success
                          failure:(InstagramFailureBlock)failure
{
    [self getPaginatedPath:[NSString stringWithFormat:@"locations/search?lat=%f&lng=%f", location.latitude, location.longitude]
                parameters:nil
             responseModel:[InstagramLocation class]
                   success:success
                   failure:failure];
}


- (void)searchLocationsAtLocation:(CLLocationCoordinate2D)location
                 distanceInMeters:(NSInteger)distance
                      withSuccess:(InstagramLocationsBlock)success
                          failure:(InstagramFailureBlock)failure
{
    [self getPaginatedPath:[NSString stringWithFormat:@"locations/search?lat=%f&lng=%f&distance=%ld", location.latitude, location.longitude, (long)distance]
                parameters:nil
             responseModel:[InstagramLocation class]
                   success:success
                   failure:failure];
}


- (void)getLocationWithId:(NSString*)locationId
              withSuccess:(InstagramLocationBlock)success
                  failure:(InstagramFailureBlock)failure
{
    [self getPath:[NSString stringWithFormat:@"locations/%@", locationId]
    responseModel:[InstagramLocation class]
          success:success
          failure:failure];
}


@end
