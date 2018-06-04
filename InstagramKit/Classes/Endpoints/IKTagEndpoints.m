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

#import "IKTagEndpoints.h"
#import "InstagramKit.h"

@implementation IKTagEndpoints


- (void)getTagDetailsWithName:(NSString *)name
                  withSuccess:(IKTagBlock)success
                      failure:(InstagramFailureBlock)failure
{
    [self getPath:[NSString stringWithFormat:@"tags/%@",name]
    responseModel:[IKTag class]
          success:success
          failure:failure];
}


- (void)getMediaWithTagName:(NSString *)tagName
                withSuccess:(IKMediaBlock)success
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
                withSuccess:(IKMediaBlock)success
                    failure:(InstagramFailureBlock)failure
{
    NSDictionary *params = [self parametersFromCount:count maxId:maxId andPaginationKey:kPaginationKeyMaxTagId];
    [self getPaginatedPath:[NSString stringWithFormat:@"tags/%@/media/recent",tagName]
                parameters:params
             responseModel:[IKMedia class]
                   success:success
                   failure:failure];
}


- (void)searchTagsWithName:(NSString *)name
               withSuccess:(IKTagsBlock)success
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
               withSuccess:(IKTagsBlock)success
                   failure:(InstagramFailureBlock)failure
{
    NSDictionary *params = [self parametersFromCount:count maxId:maxId andPaginationKey:kPaginationKeyMaxId];
    [self getPaginatedPath:[NSString stringWithFormat:@"tags/search?q=%@",name]
                parameters:params
             responseModel:[IKTag class]
                   success:success
                   failure:failure];
}


@end
