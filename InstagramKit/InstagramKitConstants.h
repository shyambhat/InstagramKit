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

#import <Foundation/Foundation.h>

#ifdef __cplusplus
#define INSTAGRAMKIT_EXTERN extern "C" __attribute__((visibility ("default")))
#else
#define INSTAGRAMKIT_EXTERN extern __attribute__((visibility ("default")))
#endif

/**
 *  Configuration Key for the Instagram API's Base URL.
 */
INSTAGRAMKIT_EXTERN NSString *const kInstagramKitBaseUrlConfigurationKey;

/**
 *  Configuration Key for the Instagram API's Authorization URL.
 */
INSTAGRAMKIT_EXTERN NSString *const kInstagramKitAuthorizationUrlConfigurationKey;

/**
 *  Instagram API's Base URL.
 */
INSTAGRAMKIT_EXTERN NSString *const kInstagramKitBaseUrl;

/**
 *  Instagram API's Authorization URL.
 */
INSTAGRAMKIT_EXTERN NSString *const kInstagramKitAuthorizationUrl;

/**
 *  Configuration Key for the Client Id of your App, registered with Instagram.
 */
INSTAGRAMKIT_EXTERN NSString *const kInstagramAppClientIdConfigurationKey;

/**
 *  Configuration Key for the Redirect URL of your App, registered with Instagram.
 */
INSTAGRAMKIT_EXTERN NSString *const kInstagramAppRedirectURLConfigurationKey;


/*!
 @typedef InstagrmaKitLoginScope enum
 
 @abstract
 Passed to indicate the scope of the access you are requesting from the user.
 
 @discussion
 All apps have basic read access by default, but if you plan on asking for extended access such as liking, commenting, or managing friendships, you need to specify these scopes in your authorization request. 
 Note that in order to use these extended permissions, first you need to submit your app for review.
 https://instagram.com/developer/authentication/#scope
 
 */
typedef NS_ENUM(NSUInteger, InstagramKitLoginScope)
{
    /*! Indicates permission to read data on a user’s behalf, e.g. recent media, following lists (granted by default) */
    InstagramKitLoginScopeBasic = 0,
    /*! Indicates permission to create or delete comments on a user’s behalf */
    InstagramKitLoginScopeComments = 1<<1,
    /*! Indicates permission to follow and unfollow accounts on a user’s behalf */
    InstagramKitLoginScopeRelationships = 1<<2,
    /*! Indicates permission to like and unlike media on a user’s behalf */
    InstagramKitLoginScopeLikes = 1<<3
};


/*!
 @abstract The error domain for all errors from InstagramKit.
 @discussion Error codes in the range 0-99 are reserved for this domain.
 */

INSTAGRAMKIT_EXTERN NSString *const InstagtamKitErrorDomain;

/*!
 @typedef NS_ENUM(NSInteger, InstagtamKitErrorCode)
 @abstract Error codes for InstagtamKitErrorDomain.
 */

typedef NS_ENUM(NSInteger, InstagtamKitErrorCode)
{
    /*!
     @abstract Reserved.
     */
    InstagramKitReservedError = 0,
    
    /*!
     @abstract The error code for errors from authentication failures.
     */
    InstagramKitAuthenticationFailedError,
    
    /*!
     @abstract The error code for errors when user cancels authentication.
     */
    InstagramKitAuthenticationCancelledError = NSUserCancelledError,
};


@class InstagramUser;
@class InstagramMedia;
@class InstagramPaginationInfo;
@class InstagramTag;
@class InstagramLocation;

typedef void (^InstagramLoginBlock)(NSError *error);
typedef void (^InstagramUserBlock)(InstagramUser *user);
typedef void (^InstagramMediaDetailBlock)(InstagramMedia *media);
typedef void (^InstagramMediaBlock)(NSArray *media, InstagramPaginationInfo *paginationInfo);
typedef void (^InstagramObjectsBlock)(NSArray *objects, InstagramPaginationInfo *paginationInfo);
typedef void (^InstagramTagsBlock)(NSArray *tags, InstagramPaginationInfo *paginationInfo);
typedef void (^InstagramTagBlock)(InstagramTag *tag);
typedef void (^InstagramCommentsBlock)(NSArray *comments);
typedef void (^InstagramUsersBlock)(NSArray *users, InstagramPaginationInfo *paginationInfo);
typedef void (^InstagramResponseBlock)(NSDictionary *serverResponse);
typedef void (^InstagramFailureBlock)(NSError* error, NSInteger serverStatusCode);
typedef void (^InstagramLocationsBlock)(NSArray *locations);
typedef void (^InstagramLocationBlock)(InstagramLocation *location);

/**
 *  String constants as represented in JSON.
 */

INSTAGRAMKIT_EXTERN NSString *const kKeyClientID;
INSTAGRAMKIT_EXTERN NSString *const kKeyAccessToken;

INSTAGRAMKIT_EXTERN NSString *const kNextURL;
INSTAGRAMKIT_EXTERN NSString *const kNextMaxId;
INSTAGRAMKIT_EXTERN NSString *const kNextMaxLikeId;
INSTAGRAMKIT_EXTERN NSString *const kNextMaxTagId;
INSTAGRAMKIT_EXTERN NSString *const kNextCursor;

INSTAGRAMKIT_EXTERN NSString *const kMaxId;
INSTAGRAMKIT_EXTERN NSString *const kMaxLikeId;
INSTAGRAMKIT_EXTERN NSString *const kMaxTagId;
INSTAGRAMKIT_EXTERN NSString *const kCursor;

INSTAGRAMKIT_EXTERN NSString *const kPagination;
INSTAGRAMKIT_EXTERN NSString *const kPaginationKeyMaxId;
INSTAGRAMKIT_EXTERN NSString *const kPaginationKeyMaxLikeId;
INSTAGRAMKIT_EXTERN NSString *const kPaginationKeyMaxTagId;
INSTAGRAMKIT_EXTERN NSString *const kPaginationKeyCursor;

INSTAGRAMKIT_EXTERN NSString *const kRelationshipActionKey;
INSTAGRAMKIT_EXTERN NSString *const kRelationshipActionFollow;
INSTAGRAMKIT_EXTERN NSString *const kRelationshipActionUnfollow;
INSTAGRAMKIT_EXTERN NSString *const kRelationshipActionBlock;
INSTAGRAMKIT_EXTERN NSString *const kRelationshipActionUnblock;
INSTAGRAMKIT_EXTERN NSString *const kRelationshipActionApprove;
INSTAGRAMKIT_EXTERN NSString *const kRelationshipActionIgnore;

#define IKNotNull(obj) (obj && (![obj isEqual:[NSNull null]]) && (![obj isEqual:@"<null>"]) )
#define IKValidDictionary(dict) (IKNotNull(dict) && [dict isKindOfClass:[NSDictionary class]])
#define IKValidArray(array) (IKNotNull(array) && [array isKindOfClass:[NSArray class]])
#define IKValidString(str) (IKNotNull(str) && [str isKindOfClass:[NSString class]])
#define IKValidNumber(num) (IKNotNull(num) && [num isKindOfClass:[NSNumber class]])
