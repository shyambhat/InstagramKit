//
//  IKUserEndpoints.m
//  InstagramKit
//
//  Created by Shyam Bhat on 6/4/18.
//

#import "IKUserEndpoints.h"
#import "InstagramKit.h"

@implementation IKUserEndpoints


- (void)getUserDetails:(NSString *)userId
           withSuccess:(InstagramUserBlock)success
               failure:(InstagramFailureBlock)failure
{
    [super getPath:[NSString stringWithFormat:@"users/%@",userId]
    responseModel:[InstagramUser class]
          success:success
          failure:failure];
}


- (void)getMediaForUser:(NSString *)userId
            withSuccess:(InstagramMediaBlock)success
                failure:(InstagramFailureBlock)failure
{
    [self getMediaForUser:userId
                    count:0
                    maxId:nil
              withSuccess:success
                  failure:failure];
}


- (void)getMediaForUser:(NSString *)userId
                  count:(NSInteger)count
                  maxId:(NSString *)maxId
            withSuccess:(InstagramMediaBlock)success
                failure:(InstagramFailureBlock)failure
{
    NSDictionary *params = [self parametersFromCount:count
                                               maxId:maxId
                                    andPaginationKey:kPaginationKeyMaxId];
    [super getPaginatedPath:[NSString stringWithFormat:@"users/%@/media/recent",userId]
                parameters:params
             responseModel:[InstagramMedia class]
                   success:success
                   failure:failure];
}


- (void)searchUsersWithString:(NSString *)name
                  withSuccess:(InstagramUsersBlock)success
                      failure:(InstagramFailureBlock)failure
{
    [super getPaginatedPath:[NSString stringWithFormat:@"users/search?q=%@",name]
                parameters:nil
             responseModel:[InstagramUser class]
                   success:success
                   failure:failure];
}


@end
