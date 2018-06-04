//
//  IKLikeEndpoints.m
//  InstagramKit
//
//  Created by Shyam Bhat on 6/4/18.
//

#import "IKLikeEndpoints.h"
#import "InstagramKit.h"

@implementation IKLikeEndpoints


- (void)getLikesOnMedia:(NSString *)mediaId
            withSuccess:(InstagramUsersBlock)success
                failure:(InstagramFailureBlock)failure
{
    [self getPaginatedPath:[NSString stringWithFormat:@"media/%@/likes",mediaId]
                parameters:nil
             responseModel:[InstagramUser class]
                   success:success
                   failure:failure];
}


- (void)likeMedia:(NSString *)mediaId
      withSuccess:(InstagramResponseBlock)success
          failure:(InstagramFailureBlock)failure
{
    [self postPath:[NSString stringWithFormat:@"media/%@/likes",mediaId]
        parameters:nil
           success:success
           failure:failure];
}


- (void)unlikeMedia:(NSString *)mediaId
        withSuccess:(InstagramResponseBlock)success
            failure:(InstagramFailureBlock)failure
{
    [self deletePath:[NSString stringWithFormat:@"media/%@/likes",mediaId]
             success:success
             failure:failure];
}


@end
