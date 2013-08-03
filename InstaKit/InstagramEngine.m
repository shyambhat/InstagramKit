//
//  InstaKit.m
//  InstaKit
//
//  Created by Shyam Bhat on 13/07/13.
//  Copyright (c) 2013 Shyam Bhat. All rights reserved.
//

#import "InstagramEngine.h"
#import "IKConstants.h"

#import "InstagramUser.h"
#import "InstagramMedia.h"

@implementation InstagramEngine

#pragma mark - Singleton -

+ (InstagramEngine *)sharedEngine
{
    return [super clientWithBaseURL:[NSURL URLWithString:kInstagramAPIBaseURL]];
//    static InstagramEngine *_sharedEngine = nil;
//    static dispatch_once_t oncePredicate;
//    dispatch_once(&oncePredicate, ^{
//        _sharedEngine = [[self alloc] initWithBaseURL:kInstagramAPIBaseURL];
//    });
//    return _sharedEngine;
}

#pragma mark - Authentication -

- (void)presentAuthenticationDialog
{
    
}

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



#pragma mark - Explore -

- (void)requestPopularMediaWithSuccess:(void (^)(NSArray *media))success failure:(void (^)(NSError *error))failure
{    
        NSString *path = [NSString stringWithFormat:@"media/popular?client_id=fe23f3a4303d4970a52b1d2ab143f60c"];
        [self bodyForPath:path method:@"GET" body:nil onCompletion:^(NSDictionary *responseBody) {
            NSArray *mediaInfo = [responseBody objectForKey:@"data"];
            NSMutableArray*objects = [NSMutableArray arrayWithCapacity:mediaInfo.count];
            for (NSDictionary *info in mediaInfo) {
                InstagramMedia *media = [[InstagramMedia alloc] initWithInfo:info];
                [objects addObject:media];
            }
            NSArray *mediaArray = [NSArray arrayWithArray:objects];
            success(mediaArray);

        } onError:^(NSError *error) {
            NSLog(@"Error : %@",error.description);
            failure(error);
        }];
}


#pragma mark - Users -

- (void)requestUserDetails:(NSString *)userID withSuccess:(void (^)(NSDictionary *userDetails))success failure:(void (^)(NSError *error))failure
{
//    NSString *path = [NSString stringWithFormat:@"media/popular?client_id=fe23f3a4303d4970a52b1d2ab143f60c"];
//    [self bodyForPath:path method:@"GET" body:nil onCompletion:^(NSDictionary *responseBody) {
//        NSArray *mediaInfo = [responseBody objectForKey:@"data"];
//        NSMutableArray*objects = [NSMutableArray arrayWithCapacity:mediaInfo.count];
//        for (NSDictionary *info in mediaInfo) {
//            InstagramMedia *media = [[InstagramMedia alloc] initWithInfo:info];
//            [objects addObject:media];
//        }
//        NSArray *mediaArray = [NSArray arrayWithArray:objects];
//        success(mediaArray);
//        
//    } onError:^(NSError *error) {
//        NSLog(@"Error : %@",error.description);
//        failure(error);
//    }];
}




@end
