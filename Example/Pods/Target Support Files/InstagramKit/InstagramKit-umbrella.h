#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "IKComment.h"
#import "IKMedia.h"
#import "IKUser.h"
#import "IKTag.h"
#import "IKLocation.h"
#import "IKPaginationInfo.h"

#import "IKSelfEndpoint.h"
#import "IKUserEndpoints.h"
#import "IKCredentialsStore.h"
#import "IKAuthorizationHelper.h"

FOUNDATION_EXPORT double InstagramKitVersionNumber;
FOUNDATION_EXPORT const unsigned char InstagramKitVersionString[];

