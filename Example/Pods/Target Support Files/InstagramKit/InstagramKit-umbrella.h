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

#import "IKAuthorizationHelper.h"
#import "IKCredentialsStore.h"
#import "IKCommentEndpoints.h"
#import "IKEndpointsBase.h"
#import "IKLikeEndpoints.h"
#import "IKLocationEndpoints.h"
#import "IKMediaEndpoints.h"
#import "IKRelationshipEndpoints.h"
#import "IKSelfEndpoints.h"
#import "IKTagEndpoints.h"
#import "IKUserEndpoints.h"
#import "IKConstants.h"
#import "InstagramKit.h"
#import "IKComment.h"
#import "IKLocation.h"
#import "IKMedia.h"
#import "IKModel.h"
#import "IKPaginationInfo.h"
#import "IKTag.h"
#import "IKUser.h"
#import "IKUserInPhoto.h"

FOUNDATION_EXPORT double InstagramKitVersionNumber;
FOUNDATION_EXPORT const unsigned char InstagramKitVersionString[];

