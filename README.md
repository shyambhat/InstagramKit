InstagramKit
==================

[![CI Status](http://img.shields.io/travis/shyambhat/InstagramKit.svg?style=flat)](https://travis-ci.org/shyambhat/InstagramKit.svg)
[![Version](https://img.shields.io/cocoapods/v/InstagramKit.svg?style=flat)](http://cocoadocs.org/docsets/InstagramKit)
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
pod 'InstagramKit', '3.6.3'
```
####Instagram Developer Registration
Head over to http://instagram.com/developer/clients/manage/ to register your app with Instagram and insert the right credentials into your App's Info.plist file.

####Authentication and Usage

For detailed instructions on configuring, authenticating and using InstagramKit, refer to the [Authentication Guide](https://github.com/shyambhat/InstagramKit/wiki/Authentication).
Download and run the Demo Project to understand how the engine is intended to be used.

Note: To use POST or DELETE requests to change likes, comments or follows, you must [apply to Instagram here](https://www.facebook.com/help/instagram/contact/185819881608116#).

Read about implementing Pagination for your requests effortlessly in the [Pagination Wiki](https://github.com/shyambhat/InstagramKit/wiki/Pagination).

####Contributions?

Glad you asked. Check out the [open Issues](https://github.com/shyambhat/InstagramKit/issues?state=open) and jump right in. Please submit pull requests to the `dev` branch.


####Questions?
The [Instagram API Documentation](http://instagram.com/developer/endpoints/) is your definitive source of information in case something goes wrong. Please make sure you've read up the documentation before posting issues.

==================

InstagramKit uses the public Instagram API and is not affiliated with either Instagram or Facebook.

If you're using InstagramKit in your App or intend to, I'd be happy to hear from you.

~ [@bhatthead](https://twitter.com/bhatthead)
