InstagramKit
==================

![Twitter: @bhatthead](https://img.shields.io/badge/contact-@bhatthead-blue.svg?style=flat)
[![CI Status](http://img.shields.io/travis/shyambhat/InstagramKit.svg?style=flat)](https://travis-ci.org/shyambhat/InstagramKit.svg)
[![Version](https://img.shields.io/cocoapods/v/InstagramKit.svg?style=flat)](http://cocoadocs.org/docsets/InstagramKit)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/InstagramKit.svg?style=flat)](http://cocoadocs.org/docsets/InstagramKit)
[![Platform](https://img.shields.io/cocoapods/p/InstagramKit.svg?style=flat)](http://cocoadocs.org/docsets/InstagramKit)

An extensive Objective C wrapper for the Instagram API, completely compatible with Swift.

Here's a quick example to retrieve trending media on Instagram:

```Objective-C
InstagramEngine *engine = [InstagramEngine sharedEngine];
[engine getPopularMediaWithSuccess:^(NSArray *media, InstagramPaginationInfo *paginationInfo) {
    // media is an array of InstagramMedia objects
    ...
} failure:^(NSError *error, NSInteger statusCode) {
    ...
}];
```

The framework is built atop AFNetworking’s blocks-based architecture and additionally, parses JSON data and creates model objects asynchronously so there’s absolutely no parsing on the main thread.
It’s neat, fast and works like a charm.

##Installation

Getting started is easy. Just include the files from the directory 'InstagramKit' into your project and you'll be up and running. You may need to add AFNetworking to your project as well if you haven't already.

####CocoaPods Podfile
```ruby
pod 'InstagramKit', '~> 3.0'
```
If your App uses authorization and you'd like the storage and retrieval of the access token to and from the Keychain to be automatically handled for you by InstagramKit, include the following pods instead -

```ruby
pod 'InstagramKit', '~> 3.0'
pod 'InstagramKit/UICKeyChainStore'
```
 
InstagramKit uses [UICKeyChainStore](https://github.com/kishikawakatsumi/UICKeyChainStore) as an optional sub-dependency for Keychain access. 
If you opt to use the optional pod, InstagramKit resumes your authenticated sessions across App launches, without needing any additional code.

#### Instagram Developer Registration
Head over to http://instagram.com/developer/clients/manage/ to register your app with Instagram and set the right credentials for ```InstagramAppClientId``` and ```InstagramAppRedirectURL``` in your App's Info.plist file. 

```InstagramAppClientId``` is your App's Client Id and ```InstagramAppRedirectURL```, the redirect URI which is obtained on registering your App on Instagram's Developer Dashboard.
The redirect URI specifies where Instagram should redirect users after they have chosen whether or not to authenticate your application. 

## Instagram Platform Updates
http://developers.instagram.com/post/133424514006/instagram-platform-update

Due to Instagram's recent update to it's API, new Apps will no longer be able to access unauthenticated requests and a few other endpoints supported by InstagramKit. An update to InstagramKit to support these changes is on it's way. 
You may refer to Instagram's API changelog here - https://www.instagram.com/developer/changelog/

##Usage

#### Authentication

For each API call, you will need an Access Token and specific scope permissions. To get the Access Token, the user needs to authenticate your app to access his Instagram account with the specified permissions.

To do so, redirect the user to ```https://instagram.com/oauth/authorize/?client_id=[Client ID]&redirect_uri=[Redirect URI]&response_type=token``` 
or allow InstagramEngine's helper method do the hard work for you - 

```Objective-C
NSURL *authURL = [[InstagramEngine sharedEngine] authorizarionURL];
[self.webView loadRequest:[NSURLRequest requestWithURL:authURL]];
```

#### Scopes
All apps have basic read access by default, but if you plan on asking for extended access such as liking, commenting, or managing friendships, you need to specify these scopes in your authorization request using the InstagramKitScope enum. 

_Note that in order to use these extended permissions, first you need to submit your app for review to Instagram._

_For your app to POST or DELETE likes, comments or follows, you must apply to Instagram here : https://www.facebook.com/help/instagram/contact/185819881608116#_

```Objective-C
// Set scope depending on permissions your App has been granted from Instagram
// InstagramKitScopeBasic is included by default.

InstagramKitScope scope = InstagramKitScopeRelationships | InstagramKitScopeComments | InstagramKitScopeLikes; 

NSURL *authURL = [[InstagramEngine sharedEngine] authorizarionURLForScope:scope];
[self.webView loadRequest:[NSURLRequest requestWithURL:authURL]];
```

Once the user grants your app permission, they will be redirected to a url in the form of something like ```http://localhost/#access_token=[access_token]``` and ```[access_token]``` will be split by a period like ```[userID].[rest of access token]```. 
InstagramEngine includes a helper method to validate this token.

```Objective-C

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSError *error;
    if ([[InstagramEngine sharedEngine] receivedValidAccessTokenFromURL:request.URL error:&error]) {
        // success!
        ...
    }
    return YES;
}
```

#### Authenticated Requests

Once you're authenticated and InstagramKit has been provided an `accessToken`, it will automatically persist it until you call `-logout` on InstagramEngine. An authenticated call looks no different:

```Objective-C
InstagramEngine *engine = [InstagramEngine sharedEngine];
[engine getSelfFeedWithSuccess:^(NSArray *media, InstagramPaginationInfo *paginationInfo) {
    // media is an array of InstagramMedia objects
    ...
} failure:^(NSError *error, NSInteger statusCode) {
    ...
}];
```

####Pagination 
The `InstagramPaginationInfo` object has everything it needs to make your next pagination call. 

If you need to make fetch a paginated feed of results, use the variation of the method which accepts `count` and `maxId` as parameters.
For instance, use `getMediaForUser:count:maxId:withSuccess:failure:` passing the next maxID to the `maxId` parameter each time, obtained from `paginationInfo.nextMaxId` of the newest paginationInfo object.

```    
[engine getMediaForUser:user.Id 
                  count:15 
                  maxId:self.currentPaginationInfo.nextMaxId 
            withSuccess:^(NSArray *media, InstagramPaginationInfo *paginationInfo) 
               {
                     if (paginationInfo) {
                         self.currentPaginationInfo = paginationInfo;
                     }
                     ...
               } 
               failure:^(NSError *error) 
               {
                     ...
               }];
```

_The first request will go with `maxId` as nil._

_Each endpoint in the Instagram API that supports pagination, usually supports a count parameter.
You can use this method and pass a count parameter to each paginated request.
You can also use it in cases where you do not need pagination, but need to specify a feed count to the first request._


Read in detail about more ways of implementing Pagination for your requests effortlessly in the [Pagination Wiki](https://github.com/shyambhat/InstagramKit/wiki/Pagination).

####Demo

Download and run the Example Project to understand how the engine is intended to be used.

##Contributions?

Glad you asked. Check out the [open Issues](https://github.com/shyambhat/InstagramKit/issues?state=open) and jump right in. Please submit pull requests to the `dev` branch.


####Questions?
The [Instagram API Documentation](http://instagram.com/developer/endpoints/) is your definitive source of information in case something goes wrong. Please make sure you've read up the documentation before posting issues.

==================

InstagramKit uses the public Instagram API and is not affiliated with either Instagram or Facebook.

If you're using InstagramKit in your App or intend to, I'd be happy to hear from you.

~ [@bhatthead](https://twitter.com/bhatthead)
