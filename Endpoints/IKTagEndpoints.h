//
//  IKTagEndpoints.h
//  InstagramKit
//
//  Created by Shyam Bhat on 6/4/18.
//

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
                  withSuccess:(InstagramTagBlock)success
                      failure:(nullable InstagramFailureBlock)failure;


/**
 *  Get a list of recently tagged media.
 *
 *  @param tagName     Name of a Tag object.
 *  @param success  Provides an array of Media objects and Pagination info.
 *  @param failure  Provides an error and a server status code.
 */
- (void)getMediaWithTagName:(NSString *)tagName
                withSuccess:(InstagramMediaBlock)success
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
                withSuccess:(InstagramMediaBlock)success
                    failure:(nullable InstagramFailureBlock)failure;


/**
 *  Search for tags by name.
 *
 *  @param name     A valid tag name without a leading #. (eg. snowy, nofilter)
 *  @param success  Provides an array of Tag objects and Pagination info.
 *  @param failure  Provides an error and a server status code.
 */
- (void)searchTagsWithName:(NSString *)name
               withSuccess:(InstagramTagsBlock)success
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
               withSuccess:(InstagramTagsBlock)success
                   failure:(nullable InstagramFailureBlock)failure;


@end

NS_ASSUME_NONNULL_END
