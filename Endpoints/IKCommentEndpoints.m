//
//  IKCommentsEndpoints.m
//  InstagramKit
//
//  Created by Shyam Bhat on 6/4/18.
//

#import "IKCommentEndpoints.h"
#import "InstagramKit.h"

@implementation IKCommentEndpoints


- (void)getCommentsOnMedia:(NSString *)mediaId
               withSuccess:(InstagramCommentsBlock)success
                   failure:(InstagramFailureBlock)failure
{
    [self getPaginatedPath:[NSString stringWithFormat:@"media/%@/comments",mediaId]
                parameters:nil
             responseModel:[InstagramComment class]
                   success:success
                   failure:failure];
}


- (void)createComment:(NSString *)commentText
              onMedia:(NSString *)mediaId
          withSuccess:(InstagramResponseBlock)success
              failure:(InstagramFailureBlock)failure
{
    NSDictionary *params = [NSDictionary dictionaryWithObjects:@[commentText] forKeys:@[@"text"]];
    [self postPath:[NSString stringWithFormat:@"media/%@/comments",mediaId]
        parameters:params
           success:success
           failure:failure];
}


- (void)removeComment:(NSString *)commentId
              onMedia:(NSString *)mediaId
          withSuccess:(InstagramResponseBlock)success
              failure:(InstagramFailureBlock)failure
{
    [self deletePath:[NSString stringWithFormat:@"media/%@/comments/%@",mediaId,commentId]
             success:success
             failure:failure];
}


@end
