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
                        
                    } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode, NSDictionary *response) {
                        XCTAssertNil(error);
                        
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

    } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode, NSDictionary *response) {
        
    }];
    
    [self waitForExpectationsWithTimeout:kTestRequestTimeout
                                 handler:^(NSError *error) {
                                     XCTAssertNil(error, @"expectation not fulfilled: %@", error);
                                 }];
}

@end
