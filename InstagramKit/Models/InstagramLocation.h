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

@interface InstagramLocation : InstagramModel

@property (readonly) CLLocationCoordinate2D coordinates;
@property (readonly) NSString *name;

@end
