//
//  IKMediaEndpoints.m
//  InstagramKit
//
//  Created by Shyam Bhat on 6/4/18.
//

#import "IKMediaEndpoints.h"
#import "InstagramMedia.h"

@implementation IKMediaEndpoints


- (void)getMedia:(NSString *)mediaId
     withSuccess:(InstagramMediaObjectBlock)success
         failure:(InstagramFailureBlock)failure
{
    [super getPath:[NSString stringWithFormat:@"media/%@",mediaId]
    responseModel:[InstagramMedia class]
          success:success
          failure:failure];
}


- (void)getMediaAtLocation:(CLLocationCoordinate2D)location
               withSuccess:(InstagramMediaBlock)success
                   failure:(InstagramFailureBlock)failure
{
    [self getMediaAtLocation:location
                       count:0
                       maxId:nil
                    distance:1000
                 withSuccess:success
                     failure:failure];
}


- (void)getMediaAtLocation:(CLLocationCoordinate2D)location
                     count:(NSInteger)count
                     maxId:(NSString *)maxId
                  distance:(CGFloat)distance
               withSuccess:(InstagramMediaBlock)success
                   failure:(InstagramFailureBlock)failure
{
    NSDictionary *params = [self parametersFromCount:count maxId:maxId andPaginationKey:kPaginationKeyMaxId];
    [super getPaginatedPath:[NSString stringWithFormat:@"media/search?lat=%f&lng=%f&distance=%f",location.latitude,location.longitude, distance]
                parameters:params
             responseModel:[InstagramMedia class]
                   success:success
                   failure:failure];
}

- (void)getMediaAtLocationWithId:(NSString*)locationId
                     withSuccess:(InstagramMediaBlock)success
                         failure:(InstagramFailureBlock)failure
{
    [super getPaginatedPath:[NSString stringWithFormat:@"locations/%@/media/recent", locationId]
                parameters:nil
             responseModel:[InstagramMedia class]
                   success:success
                   failure:failure];
}


@end
