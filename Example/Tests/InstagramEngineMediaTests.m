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

#import <XCTest/XCTest.h>
#import <InstagramKit/InstagramKit.h>
#import "InstagramKitTestsConstants.h"

@interface InstagramEngineMediaTests : XCTestCase

@end

@implementation InstagramEngineMediaTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}


- (void)testGetMedia
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Test getMedia"];
    NSString *testMediaId = @"1032802639895336381_1194245772";
    [[InstagramEngine sharedEngine] getMedia:testMediaId
              withSuccess:^(InstagramMedia * _Nonnull media) {
                  XCTAssertNotNil(media);
                  XCTAssertTrue([media isKindOfClass:[InstagramMedia class]]);
                  XCTAssertTrue([media.Id isEqualToString:testMediaId]);
                  [expectation fulfill];
              }
                  failure:^(NSError * _Nonnull error, NSInteger serverStatusCode, NSDictionary *response) {
                      XCTAssertNil(error);
              }];
    
    [self waitForExpectationsWithTimeout:kTestRequestTimeout
                                 handler:^(NSError *error) {
                                     XCTAssertNil(error, @"expectation not fulfilled: %@", error);
                                 }];
}

- (void)testGetMediaAtLocation
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Test getMediaAtLocation"];
    NSInteger testCount = 10;
    [[InstagramEngine sharedEngine] getMediaAtLocation:CLLocationCoordinate2DMake(52.520645,13.409779)
                              count:testCount
                              maxId:nil
                           distance:2000
                        withSuccess:^(NSArray<InstagramMedia *> * _Nonnull media, InstagramPaginationInfo * _Nonnull paginationInfo) {
                            XCTAssertNotNil(media);
                            XCTAssertTrue([media isKindOfClass:[NSArray class]]);
                            
                            InstagramMedia *mediaObject = media[0];
                            XCTAssertNotNil(mediaObject);
                            XCTAssertTrue([mediaObject isKindOfClass:[InstagramMedia class]]);
                            
                            XCTAssertEqual([media count], testCount);
                            [expectation fulfill];

                        }
                            failure:^(NSError * _Nonnull error, NSInteger serverStatusCode, NSDictionary *response) {
                                XCTAssertNil(error);
                        }];
    
    [self waitForExpectationsWithTimeout:kTestRequestTimeout
                                 handler:^(NSError *error) {
                                     XCTAssertNil(error, @"expectation not fulfilled: %@", error);
                                 }];
}

- (void)testGetMediaAtLocationWithId
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Test testGetMediaAtLocationWithId"];
    NSString * testLocationId = @"65045";
    [[InstagramEngine sharedEngine] getMediaAtLocationWithId:testLocationId
                        withSuccess:^(NSArray<InstagramMedia *> * _Nonnull media, InstagramPaginationInfo * _Nonnull paginationInfo) {
                            XCTAssertNotNil(media);
                            XCTAssertTrue([media isKindOfClass:[NSArray class]]);
                            
                            InstagramMedia *mediaObject = media[0];
                            XCTAssertNotNil(mediaObject);
                            XCTAssertTrue([mediaObject isKindOfClass:[InstagramMedia class]]);
                            
                            XCTAssertTrue([mediaObject.locationId isEqualToString:testLocationId]);
                            [expectation fulfill];
                            
                        }
                            failure:^(NSError * _Nonnull error, NSInteger serverStatusCode, NSDictionary *response) {
                                XCTAssertNil(error);
                        }];
    
    [self waitForExpectationsWithTimeout:kTestRequestTimeout
                                 handler:^(NSError *error) {
                                     XCTAssertNil(error, @"expectation not fulfilled: %@", error);
                                 }];
}

@end
