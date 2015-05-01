//
//  InstagramLocation.m
//  Pods
//
//  Created by Adam Juhasz on 5/1/15.
//
//

#import "InstagramLocation.h"
#import "InstagramModel.h"

@implementation InstagramLocation

- (id)initWithInfo:(NSDictionary *)info
{
    self = [super init];
    if (self && IKNotNull(info)) {
        _locationId = [[NSString alloc] initWithString:info[kLocationId]];
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = [info[kLocationLatitude] doubleValue];
        coordinate.longitude = [info[kLocationLongitude] doubleValue];
        _coordinate = coordinate;
        _name = [[NSString alloc] initWithString:info[kLocationName]];
    }
    return self;
}


@end
