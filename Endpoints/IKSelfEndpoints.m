//
//  IKSelfEndpoints.m
//  InstagramKit
//
//  Created by Shyam Bhat on 6/4/18.
//

#import "IKSelfEndpoints.h"
#import "InstagramKit.h"

@implementation IKSelfEndpoints


- (void)getSelfUserDetailsWithSuccess:(InstagramUserBlock)success
                              failure:(InstagramFailureBlock)failure
{
    [self getPath:@"users/self"
    responseModel:[InstagramUser class]
          success:success
          failure:failure];
}


- (void)getMediaLikedBySelfWithSuccess:(InstagramMediaBlock)success
                               failure:(InstagramFailureBlock)failure
{
    [self getMediaLikedBySelfWithCount:0
                                 maxId:nil
                               success:success
                               failure:failure];
}


- (void)getMediaLikedBySelfWithCount:(NSInteger)count
                               maxId:(NSString *)maxId
                             success:(InstagramMediaBlock)success
                             failure:(InstagramFailureBlock)failure
{
    NSDictionary *params = [self parametersFromCount:count
                                               maxId:maxId
                                    andPaginationKey:kPaginationKeyMaxLikeId];
    [self getPaginatedPath:[NSString stringWithFormat:@"users/self/media/liked"]
                parameters:params
             responseModel:[InstagramMedia class]
                   success:success
                   failure:failure];
}

- (void)getSelfRecentMediaWithSuccess:(InstagramMediaBlock)success
                              failure:(InstagramFailureBlock)failure
{
    [self getSelfRecentMediaWithCount:0
                                maxId:nil
                              success:success
                              failure:failure];
}


- (void)getSelfRecentMediaWithCount:(NSInteger)count
                              maxId:(NSString *)maxId
                            success:(InstagramMediaBlock)success
                            failure:(InstagramFailureBlock)failure
{
    NSDictionary *params = [self parametersFromCount:count
                                               maxId:maxId
                                    andPaginationKey:kPaginationKeyMaxId];
    [self getPaginatedPath:[NSString stringWithFormat:@"users/self/media/recent"]
                parameters:params
             responseModel:[InstagramMedia class]
                   success:success
                   failure:failure];
}


- (void)getUsersFollowedBySelfWithSuccess:(InstagramUsersBlock)success
                                  failure:(InstagramFailureBlock)failure
{
    [self getPaginatedPath:[NSString stringWithFormat:@"users/self/follows"]
                parameters:nil
             responseModel:[InstagramUser class]
                   success:success
                   failure:failure];
}

- (void)getFollowersOfSelfWithSuccess:(InstagramUsersBlock)success
                              failure:(InstagramFailureBlock)failure
{
    [self getPaginatedPath:[NSString stringWithFormat:@"users/self/followed-by"]
                parameters:nil
             responseModel:[InstagramUser class]
                   success:success
                   failure:failure];
}


@end
