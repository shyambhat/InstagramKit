//
//  IKEndpointsBase.h
//  InstagramKit
//
//  Created by Shyam Bhat on 6/4/18.
//

#import <Foundation/Foundation.h>
#import "InstagramPaginationInfo.h"
#import "IKConstants.h"

NS_ASSUME_NONNULL_BEGIN

@interface IKEndpointsBase : NSObject


/**
 *  Client Id of your App, as registered with Instagram.
 */
@property (nonatomic, readonly, nonnull) NSString *appClientID;


/**
 *  Redirect URL of your App, as registered with Instagram.
 */
@property (nonatomic, readonly, nonnull) NSString *appRedirectURL;


#pragma mark - Base Requests

- (void)getPath:(NSString *)path
  responseModel:(Class)modelClass
        success:(InstagramObjectBlock)success
        failure:(nullable InstagramFailureBlock)failure;


- (void)getPaginatedPath:(NSString *)path
              parameters:(nullable NSDictionary *)parameters
           responseModel:(Class)modelClass
                 success:(InstagramPaginatiedResponseBlock)success
                 failure:(nullable InstagramFailureBlock)failure;


- (void)postPath:(NSString *)path
      parameters:(nullable NSDictionary *)parameters
         success:(InstagramResponseBlock)success
         failure:(nullable InstagramFailureBlock)failure;


- (void)deletePath:(NSString *)path
           success:(InstagramResponseBlock)success
           failure:(nullable InstagramFailureBlock)failure;


- (NSDictionary *)parametersFromCount:(NSInteger)count maxId:(NSString *)maxId andPaginationKey:(NSString *)key;


#pragma mark - Pagination -


/**
 *  Get paginated objects as specified by information contained in the PaginationInfo object.
 *
 *  @param paginationInfo The PaginationInfo Object obtained from the previous endpoint success block.
 *  @param success        Provides an array of paginated Objects.
 *  @param failure        Provides an error and a server status code.
 */
- (void)getPaginatedItemsForInfo:(InstagramPaginationInfo *)paginationInfo
                     withSuccess:(InstagramPaginatiedResponseBlock)success
                         failure:(nullable InstagramFailureBlock)failure;


@end

NS_ASSUME_NONNULL_END
