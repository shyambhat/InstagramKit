//
//  InstagramKit.m
//  InstagramKit
//
//  Created by Shyam Bhat on 13/07/13.
//  Copyright (c) 2013 Shyam Bhat. All rights reserved.
//

#import "InstagramEngine.h"
#import "InstagramUser.h"
#import "InstagramMedia.h"

#define kInstagramAPIBaseURL @"https://api.instagram.com/v1/"
#define kInstagramAuthorizationURL @"https://api.instagram.com/oauth/authorize/"

#define kAppClientID @"fe23f3a4303d4970a52b1d2ab143f60c"
#define kAppClientSecret CypressAppClientSecret

#define kKeyClientID @"client_id"

@implementation InstagramEngine

#pragma mark - Initializers -

+ (InstagramEngine *)sharedEngine {
    static InstagramEngine *_sharedEngine = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sharedEngine = [[self alloc] initWithBaseURL:[NSURL URLWithString:kInstagramAPIBaseURL]];
    });
    return _sharedEngine;
}


- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}


#pragma mark - Authentication -

- (void)presentAuthenticationDialog
{
    
}

#pragma mark - Media -

- (void)getPopularMediaWithSuccess:(void (^)(NSArray *media))success
                           failure:(void (^)(NSError *error))failure
{
    [super getPath:@"media/popular"
        parameters:@{kKeyClientID: kAppClientID}
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        NSArray *mediaInfo = [responseDictionary objectForKey:@"data"];
        NSMutableArray*objects = [NSMutableArray arrayWithCapacity:mediaInfo.count];
        for (NSDictionary *info in mediaInfo) {
            InstagramMedia *media = [[InstagramMedia alloc] initWithInfo:info];
            [objects addObject:media];
        }
        success(objects);

    }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error : %@",error.description);
        failure(error);
    }];
}


#pragma mark - Users -

- (void)requestUserDetails:(NSString *)userID
               withSuccess:(void (^)(NSDictionary *userDetails))success
                   failure:(void (^)(NSError *error))failure
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
