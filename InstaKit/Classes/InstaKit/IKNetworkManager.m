//
//  IKNetworkManager.m
//  InstaKit
//
//  Created by Shyam Bhat on 23/07/13.
//  Copyright (c) 2013 Shyam Bhat. All rights reserved.
//

#import "IKNetworkManager.h"
#import "AFNetworking.h"
#import "IKConstants.h"

@interface IKNetworkManager (Private)
+ (NSString *)instagramBaseURL;
@end

@implementation IKNetworkManager

#pragma mark - Base Call -

-(AFJSONRequestOperation*)bodyForPath:(NSString*)path
                                 method:(NSString*)method
                                 body:(NSMutableDictionary*)body
                         onCompletion:(void (^)( NSDictionary *responseBody))completionBlock
                              onError:(void (^)( NSError *error)) errorBlock
{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",self.baseURL,path]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:method];
    AFJSONRequestOperation *op = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        completionBlock(JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        errorBlock(error);
    }];
    [op start];
    
    return op;
}

- (void)requestPopularMediaWithSuccess:(void (^)(NSArray *mediaInfo))success failure:(void (^)(NSError *error))failure
{
    NSString *path = [NSString stringWithFormat:@"media/popular?client_id=fe23f3a4303d4970a52b1d2ab143f60c"];
    [self bodyForPath:path method:@"GET" body:nil onCompletion:^(NSDictionary *responseBody) {
        success([responseBody objectForKey:@"data"]);
    } onError:^(NSError *error) {
        failure(error);
    }];
}

@end
