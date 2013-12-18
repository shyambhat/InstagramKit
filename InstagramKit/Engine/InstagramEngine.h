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

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

// #error Insert your Instagram App Credentials Here
// Head over to http://instagram.com/developer/clients/manage/ to find these.

extern NSString *const kInstagramKitAppClientIdConfigurationKey;
extern NSString *const kInstagramKitAppRedirectUrlConfigurationKey;

extern NSString *const kInstagramKitBaseUrlConfigurationKey;
extern NSString *const kInstagramKitAuthorizationUrlConfigurationKey;

extern NSString *const kInstagramKitBaseUrl __deprecated;
extern NSString *const kInstagramKitAuthorizationUrl __deprecated;

#define INSTAGRAM_AUTHORIZATION_URL kInstagramKitAuthorizationUrl
#define INSTAGRAM_BASE_URL kINstagramKidAuthorizationBaseUrl

@class InstagramMedia;
@class InstagramUser;

@interface InstagramEngine : NSObject

+ (InstagramEngine *)sharedEngine;

@property (nonatomic, copy) NSString *accessToken;

@property (nonatomic, copy) NSString *appClientID;
@property (nonatomic, copy) NSString *appRedirectURL;

@property (nonatomic, copy) NSString *authorizationURL;

#pragma mark - Media -

- (void)getPopularMediaWithSuccess:(void (^)(NSArray *media))success
                           failure:(void (^)(NSError* error))failure;

- (void)getMedia:(NSString *)mediaId
            withSuccess:(void (^)(InstagramMedia *media))success
                failure:(void (^)(NSError* error))failure;

#pragma mark - Users -

- (void)getSelfUserDetailWithSuccess:(void (^)(InstagramUser *userDetail))success
                             failure:(void (^)(NSError* error))failure;

- (void)getUserDetails:(InstagramUser *)user
           withSuccess:(void (^)(InstagramUser *userDetail))success
               failure:(void (^)(NSError* error))failure;

- (void)getMediaForUser:(NSString *)userId count:(NSInteger)count
        withSuccess:(void (^)(NSArray *feed))success
            failure:(void (^)(NSError* error))failure;

#pragma mark - Tags -

- (void)getMediaWithTag:(NSString *)tag
            withSuccess:(void (^)(NSArray *feed))success
                failure:(void (^)(NSError* error))failure;

#pragma mark - Self -

- (void)getSelfFeed:(NSInteger)count
        withSuccess:(void (^)(NSArray *feed))success
            failure:(void (^)(NSError* error))failure;

- (void)getSelfLikesWithSuccess:(void (^)(NSArray *feed))success
            failure:(void (^)(NSError* error))failure;

#pragma mark - Comments -

- (void)getCommentsOnMedia:(NSString *)mediaId
               withSuccess:(void (^)(NSArray *comments))success
                   failure:(void (^)(NSError* error))failure;

@end
