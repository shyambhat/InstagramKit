//
//  NSDictionary+IKValidation.m
//  InstagramKitDemo
//
//  Created by Charles Scalesse on 2/12/15.
//  Copyright (c) 2015 Shyam Bhat. All rights reserved.
//

#import "NSDictionary+IKValidation.h"

@implementation NSDictionary (IKValidation)

- (id)ik_objectOrNilForKey:(id)key {
    id object = [self objectForKey:key];
    if (object == [NSNull null] || [object isEqual:@"<null>"]) {
        return nil;
    }
    return object;
}

- (NSDictionary *)ik_dictionaryForKey:(id)key {
    NSDictionary *dictionary = [self ik_objectOrNilForKey:key];
    if ([dictionary isKindOfClass:[NSDictionary class]]) {
        return dictionary;
    }
    return nil;
}

- (NSArray *)ik_arrayForKey:(id)key {
    NSArray *array = [self ik_objectOrNilForKey:key];
    if ([array isKindOfClass:[NSArray class]]) {
        return array;
    }
    return nil;
}

- (NSString *)ik_stringForKey:(id)key {
    NSString *string = [self ik_objectOrNilForKey:key];
    if ([string isKindOfClass:[NSString class]]) {
        return string;
    }
    return nil;
}

- (NSNumber *)ik_numberForKey:(id)key {
    NSNumber *number = [self ik_objectOrNilForKey:key];
    if ([number isKindOfClass:[NSNumber class]]) {
        return number;
    }
    return nil;
}

- (NSURL *)ik_urlForKey:(id)key {
    NSString *urlString = [self ik_stringForKey:key];
    if (!urlString) return nil;
    return [NSURL URLWithString:urlString];
}

- (BOOL)ik_boolForKey:(id)key {
    return [[self ik_objectOrNilForKey:key] boolValue];
}

- (NSDate *)ik_dateForKey:(id)key {
    NSString *numberString = [self ik_stringForKey:key];
    if (!numberString) return nil;
    return [NSDate dateWithTimeIntervalSince1970:[numberString doubleValue]];
}

@end
