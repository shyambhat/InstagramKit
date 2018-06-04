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
