//
//    Copyright (c) 2015 Shyam Bhat
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
