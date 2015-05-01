//
//  InstagramLocation.h
//  Pods
//
//  Created by Adam Juhasz on 5/1/15.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface InstagramLocation : NSObject

@property (readonly) NSString *locationId;
@property (readonly) CLLocationCoordinate2D coordinate;
@property (readonly) NSString *name;

@end
