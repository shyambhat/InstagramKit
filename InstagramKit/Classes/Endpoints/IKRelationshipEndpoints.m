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

#import "IKRelationshipEndpoints.h"
#import "IKModelsHeader.h"

@implementation IKRelationshipEndpoints


- (void)getRelationshipStatusOfUser:(NSString *)userId
                        withSuccess:(InstagramResponseBlock)success
                            failure:(InstagramFailureBlock)failure
{
    [self getPath:[NSString stringWithFormat:@"users/%@/relationship",userId]
    responseModel:[NSDictionary class]
          success:success
          failure:failure];
}


- (void)getFollowRequestsWithSuccess:(IKUsersBlock)success
                             failure:(InstagramFailureBlock)failure
{
    [self getPaginatedPath:[NSString stringWithFormat:@"users/self/requested-by"]
                parameters:nil
             responseModel:[IKUser class]
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
