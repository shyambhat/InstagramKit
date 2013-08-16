//
//  InstagramModel.h
//  Cypress
//
//  Created by Shyam Bhat on 16/08/13.
//  Copyright (c) 2013 Shyam Bhat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InstagramModel : NSObject

@property (readonly) NSString* Id;

- (id)initWithInfo:(NSDictionary *)info;

@end


#define kID @"id"
#define kCount @"count"
#define kURL @"url"
#define kHeight @"height"
#define kWidth @"width"
#define kData @"data"
#define kLatitude @"latitude"
#define kLongitude @"longitude"

#define kThumbnail @"thumbnail"
#define kLowResolution @"low_resolution"
#define kStandardResolution @"standard_resolution"

#define kMediaTypeImage @"image"
#define kMediaTypeVideo @"videp"

#define kUser @"user"
#define kCreatedDate @"created_time"
#define kLink @"link"
#define kCaption @"caption"
#define kLikes @"likes"
#define kComments @"comments"
#define kFilter @"filter"
#define kTags @"tags"
#define kImages @"images"
#define kVideos @"videos"
#define kLocation @"location"
#define kType @"type"

#define kDate @"created_time"
#define kCreator @"from"
#define kText @"text"

#define kUsername @"username"
#define kFullName @"full_name"
#define kProfilePictureURL @"profile_picture"
#define kBio @"bio"
#define kWebsite @"website"


#define VALID_OBJECT(obj) (obj && ![obj isEqual:[NSNull null]])