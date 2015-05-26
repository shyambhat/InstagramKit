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
    self = [super initWithInfo:info];
    if (self && IKNotNull(info)) {

        CLLocationCoordinate2D coordinates;
        coordinates.latitude = [info[kLocationLatitude] doubleValue];
        coordinates.longitude = [info[kLocationLongitude] doubleValue];
        _coordinates = coordinates;
        if (IKNotNull(info[kLocationName])) {
            _name = [[NSString alloc] initWithString:info[kLocationName]];
        }
    }
    return self;
}


- (BOOL)isEqualToLocation:(InstagramLocation *)location {
    return [super isEqualToModel:location];
}

@end
