//
//  InstagramEngineUserTests.m
//  InstagramKit
//
//  Created by Shyam Bhat on 05/12/15.
//  Copyright © 2015 InstagramKit. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "InstagramKit.h"
#import "InstagramKitTestsConstants.h"

@interface InstagramEngineUserTests : XCTestCase

@property (nonatomic, strong) InstagramUser *user;

@end

@implementation InstagramEngineUserTests

- (void)setUp {
    [super setUp];
    self.user = [[InstagramUser alloc] initWithInfo:[self userDictionary]];
}

- (void)tearDown {
    [super tearDown];
}


- (NSDictionary *)userDictionary
{
    return @{
             @"full_name":@"Nails Tutorial",
             @"id":@"1194245772",
             @"profile_picture":@"https://scontent.cdninstagram.com/hphotos-xft1/t51.2885-19/11887229_102373216784481_45169835_a.jpg",
             @"username" : @"nailsartvidss"
             };
}

- (void)testGetUserDetails
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Test getUserDetails"];
    
    [[InstagramEngine sharedEngine] getUserDetails:self.user.Id
                    withSuccess:^(InstagramUser * _Nonnull responseUser) {
                        XCTAssertNotNil(responseUser);
                        XCTAssertTrue([responseUser isKindOfClass:[InstagramUser class]]);
                        
                        XCTAssertTrue([responseUser.Id isEqualToString:self.user.Id]);
                        
                        XCTAssertTrue(responseUser.mediaCount);
                        XCTAssertTrue(responseUser.followsCount);
                        XCTAssertTrue(responseUser.followedByCount);
                        
                        [expectation fulfill];
                        
                    } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
                        
                    }];
    
    [self waitForExpectationsWithTimeout:kTestRequestTimeout
                                 handler:^(NSError *error) {
                                     XCTAssertNil(error, @"expectation not fulfilled: %@", error);
                                 }];
}


- (void)testUpdateUserWithDetails
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Test updateUserWithDetails"];
    
    [self.user loadDetailsWithCompletion:^{
        XCTAssertTrue(self.user.mediaCount);
        XCTAssertTrue(self.user.followsCount);
        XCTAssertTrue(self.user.followedByCount);
        
        [expectation fulfill];

    } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
        
    }];
    
    [self waitForExpectationsWithTimeout:kTestRequestTimeout
                                 handler:^(NSError *error) {
                                     XCTAssertNil(error, @"expectation not fulfilled: %@", error);
                                 }];
}

@end
