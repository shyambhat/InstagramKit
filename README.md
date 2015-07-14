InstagramKit
==================

[![CI Status](http://img.shields.io/travis/shyambhat/InstagramKit.svg?style=flat)](https://travis-ci.org/shyambhat/InstagramKit.svg)
[![Version](https://img.shields.io/cocoapods/v/InstagramKit.svg?style=flat)](http://cocoadocs.org/docsets/InstagramKit)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/InstagramKit.svg?style=flat)](http://cocoadocs.org/docsets/InstagramKit)
[![Platform](https://img.shields.io/cocoapods/p/InstagramKit.svg?style=flat)](http://cocoadocs.org/docsets/InstagramKit)

An extensive Objective C wrapper for the Instagram API.

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

####Installation

Getting started is easy. Just include the files from the directory 'InstagramKit' into your project and you'll be up and running. You may need to add AFNetworking to your project as well if you haven't already.

####Cocoapods Podfile
```ruby
pod 'InstagramKit', '~> 3.0'
```

####Compatibility
Earliest supported deployment target = iOS 6

####Instagram Developer Registration
Head over to http://instagram.com/developer/clients/manage/ to register your app with Instagram and set the right credentials for ```InstagramAppClientId``` and ```InstagramAppRedirectURL``` in your App's Info.plist file. 

```InstagramAppClientId``` is your App's Client Id and ```InstagramAppRedirectURL```, the redirect URI which is obtained on registering your App on Instagram's Developer Dashboard.
The redirect URI specifies where Instagram should redirect users after they have chosen whether or not to authenticate your application. 

#### Authentication

In order to make Authenticated calls to the API, you need an Access Token and often times a User ID. To get your Access Token, the user needs to authenticate your app to access his Instagram account. 

To do so, redirect the user to 
```https://instagram.com/oauth/authorize/?client_id=[Client ID]&redirect_uri=[Redirect URI]&response_type=token``` 


#### Scope
All apps have basic read access by default, but if you plan on asking for extended access such as liking, commenting, or managing friendships, you need to specify these scopes in your authorization request using the IKLoginScope enum. 

_Note that in order to use these extended permissions, first you need to submit your app for review to Instagram._

_For your app to POST or DELETE likes, comments or follows, you must apply to Instagram here : https://www.facebook.com/help/instagram/contact/185819881608116#_

```Objective-C
// Set scope depending on permissions your App has been granted from Instagram
// IKLoginScopeBasic is included by default.

IKLoginScope scope = IKLoginScopeRelationships | IKLoginScopeComments | IKLoginScopeLikes; 

NSURL *authURL = [[InstagramEngine sharedEngine] authorizarionURLForScope:scope];
[mWebView loadRequest:[NSURLRequest requestWithURL:authURL]];
```

Once the user grants your app permission, they will be redirected to a url in the form of something like ```http://localhost/#access_token=[access_token]``` and ```[access_token]``` will be split by a period like ```[userID].[rest of access token]```. 
InstagramKit includes a helper method to validate this token.

```Objective-C

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSError *error;
    if ([[InstagramEngine sharedEngine] receivedValidAccessTokenWithURL:request.URL error:&error]) {
        if (!error) {
            //success!
            ...
        }
    }
    return YES;
}

```

####Usage

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
Read in detail about implementing Pagination for your requests effortlessly in the [Pagination Wiki](https://github.com/shyambhat/InstagramKit/wiki/Pagination).

####Contributions?

Glad you asked. Check out the [open Issues](https://github.com/shyambhat/InstagramKit/issues?state=open) and jump right in. Please submit pull requests to the `dev` branch.


####Questions?
The [Instagram API Documentation](http://instagram.com/developer/endpoints/) is your definitive source of information in case something goes wrong. Please make sure you've read up the documentation before posting issues.

==================

InstagramKit uses the public Instagram API and is not affiliated with either Instagram or Facebook.

If you're using InstagramKit in your App or intend to, I'd be happy to hear from you.

~ [@bhatthead](https://twitter.com/bhatthead)
