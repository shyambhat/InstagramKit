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
#import <CoreLocation/CoreLocation.h>
#import "InstagramModel.h"

@class InstagramUser;
@class InstagramComment;

@interface InstagramMedia : InstagramModel

@property (nonatomic, readonly) InstagramUser* user;
@property (nonatomic, readonly) NSDate *createdDate;
@property (nonatomic, readonly) NSString* link;
@property (nonatomic, readonly) InstagramComment* caption;
@property (nonatomic, readonly) NSInteger likesCount;
@property (nonatomic, readonly) NSArray *likes;
@property (nonatomic, readonly) NSInteger commentCount;
@property (nonatomic, readonly) NSArray *comments;
@property (nonatomic, readonly) NSArray *tags;
@property (nonatomic, readonly) CLLocationCoordinate2D location;
@property (nonatomic, readonly) NSString* filter;
@property (nonatomic, readonly) NSDictionary* images;

@property (nonatomic, readonly) NSURL *thumbnailURL;
@property (nonatomic, readonly) CGSize thumbnailFrameSize;
@property (nonatomic, readonly) NSURL *lowResolutionImageURL;
@property (nonatomic, readonly) CGSize lowResolutionImageFrameSize;
@property (nonatomic, readonly) NSURL *standardResolutionImageURL;
@property (nonatomic, readonly) CGSize standardResolutionImageFrameSize;

@property (nonatomic, readonly) BOOL isVideo;
@property (nonatomic, readonly) NSURL *lowResolutionVideoURL;
@property (nonatomic, readonly) CGSize lowResolutionVideoFrameSize;
@property (nonatomic, readonly) NSURL *standardResolutionVideoURL;
@property (nonatomic, readonly) CGSize standardResolutionVideoFrameSize;

@end
