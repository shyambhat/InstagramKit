//
//  InstagramKitTests.m
//  InstagramKitTests
//
//  Created by Shyam Bhat on 19/07/15.
//  Copyright (c) 2015 InstagramKit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "InstagramKit.h"
#import "InstagramEngine+Internal.h"

#define kTestRequestTimeout 5

static NSString *const kTestAccessToken = @"InstagramKitBaseUrl";

@interface InstagramKitTests : XCTestCase

@property (nonatomic, strong) InstagramEngine *engine;

@end

@implementation InstagramKitTests

- (void)setUp {
    [super setUp];
    self.engine = [InstagramEngine sharedEngine];
}

- (void)tearDown {
    self.engine = nil;
}


- (void)testInitialization {
    
    InstagramEngine *testEngine = [InstagramEngine sharedEngine];
    XCTAssert(testEngine, @"Pass");
    
    NSDictionary *info = [[NSBundle bundleForClass:[self class]] infoDictionary];
    XCTAssertEqual(testEngine.appClientID,info[kInstagramAppClientIdConfigurationKey]);
    XCTAssert(testEngine.appClientID);
    
    XCTAssertEqual(testEngine.appRedirectURL,info[kInstagramAppRedirectURLConfigurationKey]);
    XCTAssert(testEngine.appRedirectURL);
}


- (void)testUnauthorizedGetMediaRequest
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"completed request"];
    Class modelClass = [InstagramMedia class];
    self.engine.accessToken = nil;

    [self.engine getPath:@"media/1032802639895336381_1194245772"
              parameters:nil
           responseModel:modelClass
                 success:^(id object) {
                     XCTAssertNotNil(object);
                     XCTAssertTrue([object isKindOfClass:modelClass]);
                     [expectation fulfill];
                 }
                 failure:nil];
    
    [self waitForExpectationsWithTimeout:kTestRequestTimeout
                                 handler:^(NSError *error) {
                                     XCTAssertNil(error, @"expectation not fulfilled: %@", error);
                                 }];
}


- (void)testUnauthorizedGetUserRequest
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"completed request"];
    Class modelClass = [InstagramUser class];
    self.engine.accessToken = nil;
    
    [self.engine getPath:@"users/1194245772"
              parameters:nil
           responseModel:modelClass
                 success:^(id object) {
                     XCTAssertNotNil(object);
                     XCTAssertTrue([object isKindOfClass:modelClass]);
                     [expectation fulfill];
                 }
                 failure:nil];
    
    [self waitForExpectationsWithTimeout:kTestRequestTimeout
                                 handler:^(NSError *error) {
                                     XCTAssertNil(error, @"expectation not fulfilled: %@", error);
                                 }];
}


- (void)testUnauthorizedPaginatedRequest
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"completed request"];
    Class modelClass = [InstagramMedia class];
    self.engine.accessToken = nil;
    [self.engine getPaginatedPath:@"media/popular"
                       parameters:nil
                    responseModel:modelClass
                          success:^(NSArray *paginatedObjects, InstagramPaginationInfo *paginationInfo) {
                              XCTAssertNotNil(paginatedObjects);
                              XCTAssertTrue([paginatedObjects[0] isKindOfClass:modelClass]);
                              [expectation fulfill];
                          }
                          failure:nil];
    
    [self waitForExpectationsWithTimeout:kTestRequestTimeout
                                 handler:^(NSError *error) {
                                     XCTAssertNil(error, @"expectation not fulfilled: %@", error);
                                 }];
}


@end
