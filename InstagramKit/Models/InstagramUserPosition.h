//
//  InstagramUserPosition.h
//
//  Created by Can Poyrazoğlu on 12.07.15.
//
//

#import "InstagramModel.h"
#import "InstagramUser.h"
#import <CoreGraphics/CoreGraphics.h>

@interface InstagramUserPosition : InstagramModel

@property(readonly) CGPoint position;
@property(readonly) InstagramUser *user;

@end
