//
//  NSDictionary+IKValidation.h
//  InstagramKitDemo
//
//  Created by Charles Scalesse on 2/12/15.
//  Copyright (c) 2015 Shyam Bhat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (IKValidation)

- (id)ik_objectOrNilForKey:(id)key;
- (NSDictionary *)ik_dictionaryForKey:(id)key;
- (NSArray *)ik_arrayForKey:(id)key;
- (NSString *)ik_stringForKey:(id)key;
- (NSNumber *)ik_numberForKey:(id)key;
- (NSURL *)ik_urlForKey:(id)key;
- (BOOL)ik_boolForKey:(id)key;
- (NSDate *)ik_dateForKey:(id)key;

@end