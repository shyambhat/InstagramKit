//
//    Copyright (c) 2013 Shyam Bhat
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

#import "InstagramEngine.h"
#import "InstagramUser.h"
#import "InstagramMedia.h"
#import "InstagramComment.h"
#import "InstagramTag.h"

#define kKeyClientID @"client_id"
#define kKeyAccessToken @"access_token"

#define kData @"data"

@interface InstagramEngine()
{
    dispatch_queue_t mBackgroundQueue;
}

@end
@implementation InstagramEngine

#pragma mark - Initializers -

+ (InstagramEngine *)sharedEngine {
    static InstagramEngine *_sharedEngine = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sharedEngine = [[self alloc] initWithBaseURL:[NSURL URLWithString:INSTAGRAM_BASE_URL]];
    });
    return _sharedEngine;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
	mBackgroundQueue = dispatch_queue_create("background", NULL);
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}

#pragma mark - Base Call -

- (void)requestWithMethod:(NSString *)method path:(NSString*)path
     responseModel:(Class)modelClass
     parameters:(NSDictionary *)parameters
        success:(void (^)(id response))success
        failure:(void (^)(NSError* error, NSInteger statusCode))failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:parameters];
    if (self.accessToken) {
        [params setObject:self.accessToken forKey:kKeyAccessToken];
    }
    else
    {
        [params setObject:APP_CLIENT_ID forKey:kKeyClientID];
    }

    NSURLRequest *request = [super requestWithMethod:method path:path parameters:params];
    AFHTTPRequestOperation *operation = [super HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        BOOL multiple = ([responseDictionary[kData] isKindOfClass:[NSArray class]]);
        if (multiple) {
            NSArray *responseObjects = responseDictionary[kData];
            NSMutableArray*objects = [NSMutableArray arrayWithCapacity:responseObjects.count];
            dispatch_async(mBackgroundQueue, ^{
                if (modelClass) {
                    for (NSDictionary *info in responseObjects) {
                        id model = [[modelClass alloc] initWithInfo:info];
                        [objects addObject:model];
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(objects);
                });
            });
        }
        else {
            id model = nil;
            if (modelClass && IKNotNull(responseDictionary[kData]))
            {
                model = [[modelClass alloc] initWithInfo:responseDictionary[kData]];
            }
            success(model);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error,[[operation response] statusCode]);
    }];
    [self enqueueHTTPRequestOperation:operation];

}


#pragma mark - Media -

- (void)getPopularMediaWithSuccess:(void (^)(NSArray *media))success
                           failure:(void (^)(NSError* error))failure
{
    [self requestWithMethod:@"GET" path:@"media/popular" responseModel:[InstagramMedia class] parameters:nil success:^(id response) {
        NSArray *objects = response;
        success(objects);
    } failure:^(NSError *error, NSInteger statusCode) {
        failure(error);
    }];
}

- (void)getMedia:(NSString *)mediaId
               withSuccess:(void (^)(InstagramMedia *media))success
                   failure:(void (^)(NSError* error))failure
{
    [self requestWithMethod:@"GET" path:[NSString stringWithFormat:@"media/%@",mediaId] responseModel:[InstagramMedia class] parameters:nil success:^(id response) {
        InstagramMedia *media = response;
        success(media);
    } failure:^(NSError *error, NSInteger statusCode) {
        failure(error);
    }];
}


- (void)getMediaAtLocation:(CLLocationCoordinate2D)location
               withSuccess:(void (^)(NSArray *media))success
                   failure:(void (^)(NSError* error))failure
{
    [self requestWithMethod:@"GET" path:[NSString stringWithFormat:@"media/search?lat=%f&lng=%f",location.latitude,location.longitude] responseModel:[InstagramMedia class] parameters:nil success:^(id response) {
        NSArray *objects = response;
        success(objects);
    } failure:^(NSError *error, NSInteger statusCode) {
        failure(error);
    }];
}

#pragma mark - Users -

- (void)getUserDetails:(InstagramUser *)user
     withSuccess:(void (^)(InstagramUser *userDetail))success
         failure:(void (^)(NSError* error))failure
{
    [self requestWithMethod:@"GET" path:[NSString stringWithFormat:@"users/%@",user.Id] responseModel:[InstagramUser class] parameters:nil success:^(id response) {
        InstagramUser *userDetail = response;
        success(userDetail);
    } failure:^(NSError *error, NSInteger statusCode) {
        failure(error);
    }];
}

- (void)getMediaForUser:(NSString *)userId count:(NSInteger)count
        withSuccess:(void (^)(NSArray *feed))success
            failure:(void (^)(NSError* error))failure
{
    [self requestWithMethod:@"GET" path:[NSString stringWithFormat:@"users/%@/media/recent",userId] responseModel:[InstagramMedia class] parameters:@{[NSString stringWithFormat:@"%d",count]:kCount} success:^(id response) {
        NSArray *objects = response;
        success(objects);
    } failure:^(NSError *error, NSInteger statusCode) {
        failure(error);
    }];

}

- (void)searchUsersWithString:(NSString *)string
               withSuccess:(void (^)(NSArray *users))success
                   failure:(void (^)(NSError* error))failure
{
    [self requestWithMethod:@"GET" path:[NSString stringWithFormat:@"users/search?q=%@",string] responseModel:[InstagramUser class] parameters:nil success:^(id response) {
        NSArray *objects = response;
        success(objects);
    } failure:^(NSError *error, NSInteger statusCode) {
        failure(error);
    }];
}

#pragma mark - Tags -

- (void)getMediaWithTagName:(NSString *)tag
            withSuccess:(void (^)(NSArray *feed))success
                failure:(void (^)(NSError* error))failure
{
    [self requestWithMethod:@"GET" path:[NSString stringWithFormat:@"tags/%@/media/recent",tag] responseModel:[InstagramMedia class] parameters:nil success:^(id response) {
        NSArray *objects = response;
        success(objects);
        
    } failure:^(NSError *error, NSInteger statusCode) {
        failure(error);
    }];
    
}

- (void)getTagWithName:(NSString *)name
     withSuccess:(void (^)(InstagramTag *tag))success
         failure:(void (^)(NSError* error))failure
{
    [self requestWithMethod:@"GET" path:[NSString stringWithFormat:@"tags/%@",name] responseModel:[InstagramTag class] parameters:nil success:^(id response) {
        InstagramTag *tag = response;
        success(tag);
    } failure:^(NSError *error, NSInteger statusCode) {
        failure(error);
    }];
}

- (void)searchTagsWithName:(NSString *)name
            withSuccess:(void (^)(NSArray *tags))success
                failure:(void (^)(NSError* error))failure
{
    [self requestWithMethod:@"GET" path:[NSString stringWithFormat:@"tags/search?q=%@",name] responseModel:[InstagramTag class] parameters:nil success:^(id response) {
        NSArray *objects = response;
        success(objects);
        
    } failure:^(NSError *error, NSInteger statusCode) {
        failure(error);
    }];
    
}

#pragma mark - Self -

- (void)getSelfFeed:(NSInteger)count
        withSuccess:(void (^)(NSArray *feed))success
                failure:(void (^)(NSError* error))failure
{
    [self requestWithMethod:@"GET" path:[NSString stringWithFormat:@"users/self/feed"] responseModel:[InstagramMedia class] parameters:nil success:^(id response) {
        NSArray *objects = response;
        success(objects);
        
    } failure:^(NSError *error, NSInteger statusCode) {
        failure(error);
    }];
    
}

- (void)getSelfLikesWithSuccess:(void (^)(NSArray *feed))success
                        failure:(void (^)(NSError* error))failure
{
    [self requestWithMethod:@"GET" path:[NSString stringWithFormat:@"users/self/media/liked"] responseModel:[InstagramMedia class] parameters:nil success:^(id response) {
        NSArray *objects = response;
        success(objects);
        
    } failure:^(NSError *error, NSInteger statusCode) {
        failure(error);
    }];
    
}

#pragma mark - Comments -

- (void)getCommentsOnMedia:(InstagramMedia *)media
               withSuccess:(void (^)(NSArray *comments))success
                   failure:(void (^)(NSError* error))failure
{
    [self requestWithMethod:@"GET" path:[NSString stringWithFormat:@"media/%@/comments",media.Id] responseModel:[InstagramComment class] parameters:nil success:^(id response) {
        NSArray *objects = response;
        success(objects);
        
    } failure:^(NSError *error, NSInteger statusCode) {
        failure(error);
    }];
    
}


- (void)createComment:(NSString *)commentText
              onMedia:(InstagramMedia *)media
          withSuccess:(void (^)(void))success
              failure:(void (^)(NSError* error))failure
{
    NSDictionary *params = [NSDictionary dictionaryWithObjects:@[commentText] forKeys:@[kText]];
    [self requestWithMethod:@"POST" path:[NSString stringWithFormat:@"media/%@/comments",media.Id] responseModel:[InstagramComment class] parameters:params success:^(id response) {
        success();
        
    } failure:^(NSError *error, NSInteger statusCode) {
        failure(error);
    }];

}

- (void)removeComment:(NSString *)commentId
              onMedia:(InstagramMedia *)media
          withSuccess:(void (^)(void))success
              failure:(void (^)(NSError* error))failure
{
    [self requestWithMethod:@"DELETE" path:[NSString stringWithFormat:@"media/%@/comments/%@",media.Id,commentId] responseModel:[InstagramComment class] parameters:nil success:^(id response) {
        success();
        
    } failure:^(NSError *error, NSInteger statusCode) {
        failure(error);
    }];

}

#pragma mark - Likes -

- (void)getLikesOnMedia:(InstagramMedia *)media
               withSuccess:(void (^)(NSArray *likedUsers))success
                   failure:(void (^)(NSError* error))failure
{
    [self requestWithMethod:@"GET" path:[NSString stringWithFormat:@"media/%@/likes",media.Id] responseModel:[InstagramUser class] parameters:nil success:^(id response) {
        NSArray *objects = response;
        success(objects);
        
    } failure:^(NSError *error, NSInteger statusCode) {
        failure(error);
    }];
    
}

- (void)likeMedia:(InstagramMedia *)media
              withSuccess:(void (^)(void))success
          failure:(void (^)(NSError* error))failure
{
    [self requestWithMethod:@"POST" path:[NSString stringWithFormat:@"media/%@/likes",media.Id] responseModel:nil parameters:nil success:^(id response) {
        success();
        
    } failure:^(NSError *error, NSInteger statusCode) {
        failure(error);
    }];
    
}

- (void)unlikeMedia:(InstagramMedia *)media
        withSuccess:(void (^)(void))success
          failure:(void (^)(NSError* error))failure
{
    [self requestWithMethod:@"DELETE" path:[NSString stringWithFormat:@"media/%@/likes",media.Id] responseModel:nil parameters:nil success:^(id response) {
        success();
        
    } failure:^(NSError *error, NSInteger statusCode) {
        failure(error);
    }];

}

@end
