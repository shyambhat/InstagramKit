//
//  IKTagEndpoints.m
//  InstagramKit
//
//  Created by Shyam Bhat on 6/4/18.
//

#import "IKTagEndpoints.h"
#import "InstagramKit.h"

@implementation IKTagEndpoints


- (void)getTagDetailsWithName:(NSString *)name
                  withSuccess:(InstagramTagBlock)success
                      failure:(InstagramFailureBlock)failure
{
    [self getPath:[NSString stringWithFormat:@"tags/%@",name]
    responseModel:[InstagramTag class]
          success:success
          failure:failure];
}


- (void)getMediaWithTagName:(NSString *)tagName
                withSuccess:(InstagramMediaBlock)success
                    failure:(InstagramFailureBlock)failure
{
    [self getMediaWithTagName:tagName
                        count:0
                        maxId:nil
                  withSuccess:success
                      failure:failure];
}


- (void)getMediaWithTagName:(NSString *)tagName
                      count:(NSInteger)count
                      maxId:(NSString *)maxId
                withSuccess:(InstagramMediaBlock)success
                    failure:(InstagramFailureBlock)failure
{
    NSDictionary *params = [self parametersFromCount:count maxId:maxId andPaginationKey:kPaginationKeyMaxTagId];
    [self getPaginatedPath:[NSString stringWithFormat:@"tags/%@/media/recent",tagName]
                parameters:params
             responseModel:[InstagramMedia class]
                   success:success
                   failure:failure];
}


- (void)searchTagsWithName:(NSString *)name
               withSuccess:(InstagramTagsBlock)success
                   failure:(InstagramFailureBlock)failure
{
    [self searchTagsWithName:name
                       count:0
                       maxId:nil
                 withSuccess:success
                     failure:failure];
}


- (void)searchTagsWithName:(NSString *)name
                     count:(NSInteger)count
                     maxId:(NSString *)maxId
               withSuccess:(InstagramTagsBlock)success
                   failure:(InstagramFailureBlock)failure
{
    NSDictionary *params = [self parametersFromCount:count maxId:maxId andPaginationKey:kPaginationKeyMaxId];
    [self getPaginatedPath:[NSString stringWithFormat:@"tags/search?q=%@",name]
                parameters:params
             responseModel:[InstagramTag class]
                   success:success
                   failure:failure];
}


@end
