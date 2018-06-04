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

NS_ASSUME_NONNULL_BEGIN

@interface IKTagEndpoints : IKEndpointsBase


/**
 *  Get information about a tag object.
 *
 *  @param name     Name of a Tag object.
 *  @param success  Provides a Tag object.
 *  @param failure  Provides an error and a server status code.
 */
- (void)getTagDetailsWithName:(NSString *)name
                  withSuccess:(IKTagBlock)success
                      failure:(nullable InstagramFailureBlock)failure;


/**
 *  Get a list of recently tagged media.
 *
 *  @param tagName     Name of a Tag object.
 *  @param success  Provides an array of Media objects and Pagination info.
 *  @param failure  Provides an error and a server status code.
 */
- (void)getMediaWithTagName:(NSString *)tagName
                withSuccess:(IKMediaBlock)success
                    failure:(nullable InstagramFailureBlock)failure;


/**
 *  Get a list of recently tagged media.
 *
 *  @param tagName  Name of a Tag object.
 *  @param count    Count of objects to fetch.
 *  @param maxId    The nextMaxId from the previously obtained PaginationInfo object.
 *  @param success  Provides an array of Media objects and Pagination info.
 *  @param failure  Provides an error and a server status code.
 */
- (void)getMediaWithTagName:(NSString *)tagName
                      count:(NSInteger)count
                      maxId:(nullable NSString *)maxId
                withSuccess:(IKMediaBlock)success
                    failure:(nullable InstagramFailureBlock)failure;


/**
 *  Search for tags by name.
 *
 *  @param name     A valid tag name without a leading #. (eg. snowy, nofilter)
 *  @param success  Provides an array of Tag objects and Pagination info.
 *  @param failure  Provides an error and a server status code.
 */
- (void)searchTagsWithName:(NSString *)name
               withSuccess:(IKTagsBlock)success
                   failure:(nullable InstagramFailureBlock)failure;


/**
 *  Search for tags by name.
 *
 *  @param name     A valid tag name without a leading #. (eg. snowy, nofilter)
 *  @param count    Count of objects to fetch.
 *  @param maxId    The nextMaxId from the previously obtained PaginationInfo object.
 *  @param success  Provides an array of Tag objects and Pagination info.
 *  @param failure  Provides an error and a server status code.
 */
- (void)searchTagsWithName:(NSString *)name
                     count:(NSInteger)count
                     maxId:(nullable NSString *)maxId
               withSuccess:(IKTagsBlock)success
                   failure:(nullable InstagramFailureBlock)failure;


@end

NS_ASSUME_NONNULL_END
