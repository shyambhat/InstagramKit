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

#import "InstagramLocation.h"
#import "InstagramModel.h"

@interface InstagramLocation ()

@property (nonatomic, assign) CLLocationCoordinate2D coordinates;
@property (nonatomic, copy) NSString *name;

@end

@implementation InstagramLocation

- (id)initWithInfo:(NSDictionary *)info
{
    self = [super initWithInfo:info];
    if (self && IKNotNull(info)) {

        CLLocationCoordinate2D coordinates;
        coordinates.latitude = [info[kLocationLatitude] doubleValue];
        coordinates.longitude = [info[kLocationLongitude] doubleValue];
        self.coordinates = coordinates;
        self.name =  IKNotNull(info[kLocationName]) ? [[NSString alloc] initWithString:info[kLocationName]] : nil;
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
    if ((self = [super initWithCoder:decoder])) {
        CLLocationCoordinate2D coordinates;
        coordinates.latitude = [decoder decodeDoubleForKey:kLocationLatitude];
        coordinates.longitude = [decoder decodeDoubleForKey:kLocationLongitude];
        self.coordinates = coordinates;
        self.name = [decoder decodeObjectOfClass:[NSString class] forKey:kLocationName];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];

    [encoder encodeDouble:self.coordinates.latitude forKey:kLocationLatitude];
    [encoder encodeDouble:self.coordinates.longitude forKey:kLocationLongitude];
    [encoder encodeObject:self.name forKey:kLocationName];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    InstagramLocation *copy = [super copyWithZone:zone];
    copy->_coordinates = self.coordinates;
    copy->_name = [self.name copy];
    return copy;
}

@end
