//
//  InstagramEngine+Relationships.m
//  InstagramKit
//
//  Created by Shyam Bhat on 6/4/18.
//

#import "InstagramEngine+Relationships.h"

@implementation InstagramEngine (Relationships)


- (void)getRelationshipStatusOfUser:(NSString *)userId
                        withSuccess:(InstagramResponseBlock)success
                            failure:(InstagramFailureBlock)failure
{
    [self getPath:[NSString stringWithFormat:@"users/%@/relationship",userId]
       parameters:nil
    responseModel:[NSDictionary class]
          success:success
          failure:failure];
}


- (void)getFollowRequestsWithSuccess:(InstagramUsersBlock)success
                             failure:(InstagramFailureBlock)failure
{
    [self getPaginatedPath:[NSString stringWithFormat:@"users/self/requested-by"]
                parameters:nil
             responseModel:[InstagramUser class]
                   success:success
                   failure:failure];
}


- (void)followUser:(NSString *)userId
       withSuccess:(InstagramResponseBlock)success
           failure:(InstagramFailureBlock)failure
{
    NSDictionary *params = @{kRelationshipActionKey:kRelationshipActionFollow};
    [self postPath:[NSString stringWithFormat:@"users/%@/relationship",userId]
        parameters:params
           success:success
           failure:failure];
}


- (void)unfollowUser:(NSString *)userId
         withSuccess:(InstagramResponseBlock)success
             failure:(InstagramFailureBlock)failure
{
    NSDictionary *params = @{kRelationshipActionKey:kRelationshipActionUnfollow};
    [self postPath:[NSString stringWithFormat:@"users/%@/relationship",userId]
        parameters:params
           success:success
           failure:failure];
}


- (void)blockUser:(NSString *)userId
      withSuccess:(InstagramResponseBlock)success
          failure:(InstagramFailureBlock)failure
{
    NSDictionary *params = @{kRelationshipActionKey:kRelationshipActionBlock};
    [self postPath:[NSString stringWithFormat:@"users/%@/relationship",userId]
        parameters:params
           success:success
           failure:failure];
}


- (void)unblockUser:(NSString *)userId
        withSuccess:(InstagramResponseBlock)success
            failure:(InstagramFailureBlock)failure
{
    NSDictionary *params = @{kRelationshipActionKey:kRelationshipActionUnblock};
    [self postPath:[NSString stringWithFormat:@"users/%@/relationship",userId]
        parameters:params
           success:success
           failure:failure];
}


- (void)approveUser:(NSString *)userId
        withSuccess:(InstagramResponseBlock)success
            failure:(InstagramFailureBlock)failure
{
    NSDictionary *params = @{kRelationshipActionKey:kRelationshipActionApprove};
    [self postPath:[NSString stringWithFormat:@"users/%@/relationship",userId]
        parameters:params
           success:success
           failure:failure];
}


- (void)ignoreUser:(NSString *)userId
       withSuccess:(InstagramResponseBlock)success
           failure:(InstagramFailureBlock)failure
{
    NSDictionary *params = @{kRelationshipActionKey:kRelationshipActionIgnore};
    [self postPath:[NSString stringWithFormat:@"users/%@/relationship",userId]
        parameters:params
           success:success
           failure:failure];
}


@end
