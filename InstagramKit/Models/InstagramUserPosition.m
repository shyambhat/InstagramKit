//
//  InstagramUserPosition.m
//
//  Created by Can Poyrazoğlu on 12.07.15.
//
//

#import "InstagramUserPosition.h"

@implementation InstagramUserPosition{
    CGPoint mPosition;
    InstagramUser *mUser;
}

@synthesize position = mPosition;
@synthesize user = mUser;

- (id)initWithInfo:(NSDictionary *)info
{
    self = [super initWithInfo:info];
    if (self && IKNotNull(info)) {
        NSDictionary *position = info[kPosition];
        CGFloat positionX = [position[kX] floatValue];
        CGFloat positionY = [position[kY] floatValue];
        mPosition = CGPointMake(positionX, positionY);
        NSDictionary *user = info[kUser];
        mUser = [[InstagramUser alloc] initWithInfo:user];
    }
    return self;
}

@end
