InstagramKit
==================

An extensive Objective C wrapper for the Instagram API. 

This framework is built atop AFNetworking’s blocks-based architecture and additionally parses the JSON response asynchronously so there’s absolutely no parsing on the main thread. 
It’s neat, fast and works like a charm providing an easy interface to interacting with Instagram’s model objects.



#### Changelog:
Version 3.5.0 includes accessors for relationship endpoints to follow, unfollow, block, unblock, approve or deny other users.

Version 3.1.0 adds support for seamless pagination.

Read about implementing Pagination effortlessly in the [Pagination Wiki](https://github.com/shyambhat/InstagramKit/wiki/Pagination).


##Installation


Getting started is easy. Just include the files from the directory 'InstagramKit' into your project and you'll be up and running. You may need to add AFNetworking to your project as well if you haven't already.

##### Cocoapods Podfile:
```ruby
pod 'InstagramKit', '3.5.0'
```
#### Instagram Developer Registration
Head over to http://instagram.com/developer/clients/manage/ to register your app with Instagram and insert the right credentials in InstagramKit.plist. 
If you prefer the Info.plist for all your app settings, you can include these keys directly in your info.plist file.

##Usage

Inside the files that you want to use InstagramKit, you have to make sure you add the .h file. 

In order to make calls to the API, you need an Access Token and often times a User ID. To get your Access Token, the user needs to authenticate your app. To do so, send the user to ```https://instagram.com/oauth/authorize/?client_id=[Client ID]&redirect_uri=[Redirect URI]&response_type=token``` with ```[Client ID]``` being replaced with the Client ID you received from the Instagram Developer Dashboard and ```[Redirect URI]``` being replaced with whatever you like. You can use http://localhost as well if you don't need to access a backend of any sort. 

Once the user grants your app permission, they will be redirected to a url in the form of something like ```http://localhost/#access_token=[access_token]``` and ```[access_token]``` will be split by a period like ```[userID].[rest of access token]```. Once you have the Access Token and User ID saved, you can create a Instagram Engine object and start using the various methods available. Below is an example of how to retrieve the media from a user's feed:

```Objective-C
//This is the object used to get data from the user's feed
InstagramEngine *engine = [InstagramEngine sharedEngine];
engine.accessToken = token;//Token received from redirect url
[engine getMediaForUser:userID count:20 maxId:nil  withSuccess:^(NSArray *media, InstagramPaginationInfo *paginationInfo) {
 	//media is now array of InstagramMedia objects that can be used       
    } failure:^(NSError *error) {
      //Handle error here
    }];
```

## Demo

Download and run the Demo Project to understand how the engine is intended to be used. 

<img src='https://raw.githubusercontent.com/shyambhat/InstagramKit/master/InstagramKitDemo/Instagramkit_demo.png' alt='Screenshot' width=310.5 height=625.5 />



### Contributions?

Glad you asked. Check out the [open Issues](https://github.com/shyambhat/InstagramKit/issues?state=open) and jump right in.


Questions? 
The [Instagram API Documentation](http://instagram.com/developer/endpoints/) is your definitive source of information in case something goes wrong. Please make sure you've read up the document thoroughly before posting issues.

==================


InstagramKit uses the public Instagram API and is not affiliated with either Instagram or Facebook.

If you're using InstagramKit in your app or intend to, I'd be happy to hear from you. 

~ [@bhatthead](https://twitter.com/bhatthead)
