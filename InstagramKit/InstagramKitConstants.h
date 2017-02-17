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

NS_ASSUME_NONNULL_BEGIN

#ifdef __cplusplus
#define INSTAGRAMKIT_EXTERN extern "C" __attribute__((visibility ("default")))
#else
#define INSTAGRAMKIT_EXTERN extern __attribute__((visibility ("default")))
#endif

#define INSTAGRAMKIT_TEST_TARGET [[[NSProcessInfo processInfo] arguments] containsObject:@"-FNTesting"]

#define INSTAGRAMKIT_UICKEYCHAINSTORE __has_include("UICKeyChainStore.h")

/**
 *  Configuration Key for the Instagram API's Base URL.
 */
INSTAGRAMKIT_EXTERN NSString *const kInstagramKitBaseURLConfigurationKey;

/**
 *  Configuration Key for the Instagram API's Authorization URL.
 */
INSTAGRAMKIT_EXTERN NSString *const kInstagramKitAuthorizationURLConfigurationKey;

/**
 *  Instagram API's Base URL.
 */
INSTAGRAMKIT_EXTERN NSString *const kInstagramKitBaseURL;

/**
 *  Instagram API's Authorization URL.
 */
INSTAGRAMKIT_EXTERN NSString *const kInstagramKitAuthorizationURL;

/**
 *  Configuration Key for the Client Id of your App, registered with Instagram.
 */
INSTAGRAMKIT_EXTERN NSString *const kInstagramAppClientIdConfigurationKey;

/**
 *  Configuration Key for the Redirect URL of your App, registered with Instagram.
 */
INSTAGRAMKIT_EXTERN NSString *const kInstagramAppRedirectURLConfigurationKey;


/*!
 @typedef   InstagrmaKitLoginScope enum
 
 @abstract  Passed to indicate the scope of the access you are requesting from the user.
 
 @discussion
 All apps have basic read access by default, but if you plan on asking for extended access such as liking, commenting, or managing friendships, you need to specify these scopes in your authorization request. 
 Note that in order to use these extended permissions, first you need to submit your app for review.
 https://instagram.com/developer/authentication/#scope
 
 */
typedef NS_OPTIONS(NSUInteger, InstagramKitLoginScope)
{
    /*! Indicates permission to read data on a user’s behalf, e.g. recent media, following lists (granted by default) */
    InstagramKitLoginScopeBasic = 0,
    /*! Indicates permission to create or delete comments on a user’s behalf */
    InstagramKitLoginScopeComments = 1<<1,
    /*! Indicates permission to follow and unfollow accounts on a user’s behalf */
    InstagramKitLoginScopeRelationships = 1<<2,
    /*! Indicates permission to like and unlike media on a user’s behalf */
    InstagramKitLoginScopeLikes = 1<<3,
    /*! Indicates permission to read any public profile info and media on a user’s behalf */
    InstagramKitLoginScopePublicContent = 1<<4,
    /*! Indicates permission to read the list of followers and followed-by users */
    InstagramKitLoginScopeFollowerList = 1<<5
};


/*!
 @abstract      The notification posted on changing the authentication token.
 */
INSTAGRAMKIT_EXTERN NSString *const InstagramKitUserAuthenticationChangedNotification;


/*!
 @abstract      The error domain for all errors from InstagramKit.
 @discussion    Error codes in the range 0-99 are reserved for this domain.
 */
INSTAGRAMKIT_EXTERN NSString *const InstagramKitErrorDomain;


/*!
 @abstract      The Keychain Store service from InstagramKit to securely store credentials.
 */
INSTAGRAMKIT_EXTERN NSString *const InstagramKitKeychainStore;


/*!
 @typedef       NS_ENUM(NSInteger, InstagramKitErrorCode)
 @abstract      Error codes for InstagramKitErrorDomain.
 */
typedef NS_ENUM(NSInteger, InstagramKitErrorCode)
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
@class InstagramComment;
@class InstagramPaginationInfo;
@class InstagramTag;
@class InstagramLocation;
@class InstagramModel;

/**
 *  A generic block used as a callback for receiving a collection of objects.
 *
 *  @param paginatedObjects Array of Instagram model objects.
 *  @param paginationInfo   A PaginationInfo object.
 */
typedef void (^InstagramPaginatiedResponseBlock)(NSArray<InstagramModel *> *paginatedObjects, InstagramPaginationInfo *paginationInfo);

/**
 *  A generic block used as a callback for receiving a single object.
 *
 *  @param model    An Instagram model object.
 */
typedef void (^InstagramObjectBlock)(id object);

/**
 *  A callback block providing a collection of Media objects.
 *
 *  @param media            An array of InstagramMedia objects.
 *  @param paginationInfo   A PaginationInfo object.
 */
typedef void (^InstagramMediaBlock)(NSArray<InstagramMedia *> *media, InstagramPaginationInfo *paginationInfo);

/**
 *  A callback block providing a collection of User objects.
 *
 *  @param users            An array of User objects.
 *  @param paginationInfo   A PaginationInfo object.
 */
typedef void (^InstagramUsersBlock)(NSArray<InstagramUser *> *users, InstagramPaginationInfo *paginationInfo);

/**
 *  A callback block providing a collection of Location objects.
 *
 *  @param locations        An array of InstagramLocation objects.
 *  @param paginationInfo   A PaginationInfo object.
 */
typedef void (^InstagramLocationsBlock)(NSArray<InstagramLocation *> *locations, InstagramPaginationInfo *paginationInfo);

/**
 *  A callback block providing a collection of Comment objects.
 *
 *  @param comments         An array of InstagramComment objects.
 *  @param paginationInfo   A PaginationInfo object.
 */
typedef void (^InstagramCommentsBlock)(NSArray<InstagramComment *> *comments, InstagramPaginationInfo *paginationInfo);

/**
 *  A callback block providing a collection of Tag objects.
 *
 *  @param tags             An array of Tag objects.
 *  @param paginationInfo   A PaginationInfo object.
 */
typedef void (^InstagramTagsBlock)(NSArray<InstagramTag *> *tags, InstagramPaginationInfo *paginationInfo);

/**
 *  A callback block providing a User object.
 *
 *  @param user     An InstagramUser object.
 */
typedef void (^InstagramUserBlock)(InstagramUser *user);

/**
 *  A callback block providing a Media object.
 *
 *  @param media    An InstagraMedia object.
 */
typedef void (^InstagramMediaObjectBlock)(InstagramMedia *media);

/**
 *  A callback block providing a Tag object.
 *
 *  @param tag An InstagramTag object.
 */
typedef void (^InstagramTagBlock)(InstagramTag *tag);

/**
 *  A callback block providing a Location object.
 *
 *  @param location An InstagramLocation object.
 */
typedef void (^InstagramLocationBlock)(InstagramLocation *location);

/**
 *  A generic failure block for handling server errors.
 *
 *  @param error
 *  @param serverStatusCode 
 */
typedef void (^InstagramFailureBlock)(NSError* error, NSInteger serverStatusCode);

/**
 *  A generic response block providing the server response dictionary, as is.
 *
 *  @param serverResponse Response JSON in dictionary form.
 */
typedef void (^InstagramResponseBlock)(NSDictionary *serverResponse);


/**
 *  String constants as represented in JSON.
 */

INSTAGRAMKIT_EXTERN NSString *const kKeyClientID;
INSTAGRAMKIT_EXTERN NSString *const kKeyAccessToken;
INSTAGRAMKIT_EXTERN NSString *const kKeychainTokenKey;

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

NS_ASSUME_NONNULL_END
