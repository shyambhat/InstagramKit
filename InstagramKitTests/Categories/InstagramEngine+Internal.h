//
//  InstagramEngine+Internal.h
//  InstagramKit
//
//  Created by Shyam Bhat on 20/07/15.
//  Copyright (c) 2015 InstagramKit. All rights reserved.
//

#import "InstagramEngine.h"

@interface InstagramEngine (Internal)

- (NSURL *)authorizarionURLForScope:(InstagramKitLoginScope)scope;

- (BOOL)receivedValidAccessTokenFromURL:(NSURL *)url
                                  error:(NSError *__autoreleasing *)error;

- (void)logout;

- (NSString *)stringForScope:(InstagramKitLoginScope)scope;

- (NSDictionary *)queryStringParametersFromString:(NSString*)string;



- (void)getPath:(NSString *)path
     parameters:(NSDictionary *)parameters
  responseModel:(Class)modelClass
        success:(InstagramObjectBlock)success
        failure:(InstagramFailureBlock)failure;


- (void)getPaginatedPath:(NSString *)path
              parameters:(NSDictionary *)parameters
           responseModel:(Class)modelClass
                 success:(InstagramPaginatiedResponseBlock)success
                 failure:(InstagramFailureBlock)failure;


- (void)postPath:(NSString *)path
      parameters:(NSDictionary *)parameters
   responseModel:(Class)modelClass
         success:(InstagramResponseBlock)success
         failure:(InstagramFailureBlock)failure;


- (void)deletePath:(NSString *)path
        parameters:(NSDictionary *)parameters
     responseModel:(Class)modelClass
           success:(InstagramResponseBlock)success
           failure:(InstagramFailureBlock)failure;


@end
