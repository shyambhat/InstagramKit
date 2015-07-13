//
//  InstagramLocation.h
//  Pods
//
//  Created by Adam Juhasz on 5/1/15.
//
//

#import <Foundation/Foundation.h>
#import "InstagramModel.h"
#import <MapKit/MapKit.h>

@interface InstagramLocation : InstagramModel <NSCopying, NSSecureCoding, NSObject>

/**
 *  Geographic coordinates if the Location.
 */
@property (readonly) CLLocationCoordinate2D coordinates;

/**
 *  Location name as provided by the API.
 */
@property (readonly) NSString *name;

/**
 *  Comparing InstagramLocation objects.
 *  @param location An InstagramLocation object.
 *  @return         YES is Ids match. Else NO.
 */
- (BOOL)isEqualToLocation:(InstagramLocation *)location;

@end
