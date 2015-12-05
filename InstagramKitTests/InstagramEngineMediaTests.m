//
//  InstagramEngine+MediaTests.m
//  InstagramKit
//
//  Created by Shyam Bhat on 05/12/15.
//  Copyright © 2015 InstagramKit. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "InstagramKit.h"
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
                  failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
                      
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
    [[InstagramEngine sharedEngine] getMediaAtLocation:CLLocationCoordinate2DMake(52.5220257,13.4437056)
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
                            failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
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
                            failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
                        }];
    
    [self waitForExpectationsWithTimeout:kTestRequestTimeout
                                 handler:^(NSError *error) {
                                     XCTAssertNil(error, @"expectation not fulfilled: %@", error);
                                 }];
}

@end
