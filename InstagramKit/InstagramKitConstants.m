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

#import "InstagramKitConstants.h"

NSString *const kInstagramKitBaseURLConfigurationKey = @"InstagramKitBaseUrl";
NSString *const kInstagramKitAuthorizationURLConfigurationKey = @"InstagramKitAuthorizationUrl";
NSString *const kInstagramKitBaseURL = @"https://api.instagram.com/v1/";
NSString *const kInstagramKitAuthorizationURL = @"https://api.instagram.com/oauth/authorize/";

NSString *const kInstagramAppClientIdConfigurationKey = @"InstagramAppClientId";
NSString *const kInstagramAppRedirectURLConfigurationKey = @"InstagramAppRedirectURL";

NSString *const InstagramKitUserAuthenticationChangedNotification = @"com.instagramkit.token.change";
NSString *const InstagramKitErrorDomain = @"com.instagramkit";
NSString *const InstagramKitKeychainStore = @"com.instagramkit.secure";

NSString *const kKeyClientID = @"client_id";
NSString *const kKeyAccessToken = @"access_token";
NSString *const kKeychainTokenKey = @"token";

NSString *const kPagination = @"pagination";
NSString *const kPaginationKeyMaxId = @"max_id";
NSString *const kPaginationKeyMaxLikeId = @"max_like_id";
NSString *const kPaginationKeyMaxTagId = @"max_tag_id";
NSString *const kPaginationKeyCursor = @"cursor";

NSString *const kRelationshipActionKey = @"action";
NSString *const kRelationshipActionFollow = @"follow";
NSString *const kRelationshipActionUnfollow = @"unfollow";
NSString *const kRelationshipActionBlock = @"block";
NSString *const kRelationshipActionUnblock = @"unblock";
NSString *const kRelationshipActionApprove = @"approve";
NSString *const kRelationshipActionIgnore = @"ignore";
