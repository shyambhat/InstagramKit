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

@interface IKMediaEndpoints : IKEndpointsBase


/**
 *  Get information about a Media object.
 *
 *  @param mediaId  Id of a Media object.
 *  @param success  Provides a fully populated Media object.
 *  @param failure  Provides an error and a server status code.
 */
- (void)getMedia:(NSString *)mediaId
     withSuccess:(IKMediaObjectBlock)success
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
               withSuccess:(IKMediaBlock)success
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
               withSuccess:(IKMediaBlock)success
                   failure:(nullable InstagramFailureBlock)failure;

/**
 *  Get a list of recent media objects from a given location.
 *
 *  @param locationId   Id of a Location object.
 *  @param success      Provides an array of Media objects and Pagination info.
 *  @param failure      Provides an error and a server status code.
 */
- (void)getMediaAtLocationWithId:(NSString*)locationId
                     withSuccess:(IKMediaBlock)success
                         failure:(nullable InstagramFailureBlock)failure;


@end

NS_ASSUME_NONNULL_END

