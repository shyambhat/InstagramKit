//
//  IGMedia.m
//  InstagramKit
//
//  Created by Shyam Bhat on 13/07/13.
//  Copyright (c) 2013 Shyam Bhat. All rights reserved.
//

#import "InstagramMedia.h"

@implementation InstagramMedia

- (id)initWithInfo:(NSDictionary *)info
{
    self = [super init];
    if (self) {
        // Temporary messy checks
        NSString *linkURL =[info objectForKey:@"link"];
        if (linkURL && (![linkURL isEqualToString:@"<null>"]) && (linkURL !=nil) ) {
            self.linkUrl = linkURL;
        }
        id caption = [info  objectForKey:@"caption"];
        if ([caption isKindOfClass:[NSDictionary class]]) {
            NSString *text = [caption objectForKey:@"text"];
            if (text && (![text isEqualToString:@"<null>"]) && (text !=nil) )
                self.caption = text;
        }
    }
    return self;
}

@end
