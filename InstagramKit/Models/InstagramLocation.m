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

#pragma mark - Equality

- (BOOL)isEqualToLocation:(InstagramLocation *)location {
    return [super isEqualToModel:location];
}

#pragma mark - NSCoding

+ (BOOL)supportsSecureCoding
{
    return YES;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [self init])) {
        CLLocationCoordinate2D coordinates;
        coordinates.latitude = [decoder decodeDoubleForKey:kLocationLatitude];
        coordinates.longitude = [decoder decodeDoubleForKey:kLocationLongitude];
        _coordinates = coordinates;
        _name = [decoder decodeObjectOfClass:[NSString class] forKey:kLocationName];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeDouble:_coordinates.latitude forKey:kLocationLatitude];
    [encoder encodeDouble:_coordinates.longitude forKey:kLocationLongitude];
    [encoder encodeObject:_name forKey:kLocationName];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    InstagramLocation *copy = [super copyWithZone:zone];
    copy->_coordinates = _coordinates;
    copy->_name = [_name copy];
    return copy;
}

@end
