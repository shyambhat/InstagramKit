InstagramKit
==================

An extensive Objective C wrapper for the Instagram API. 

This framework is built atop AFNetworking’s blocks-based architecture and additionally parses the JSON response asynchronously so there’s absolutely no parsing on the main thread. 
It’s neat, fast and works like a charm providing an easy interface to interacting with Instagram’s model objects.



#### Changelog:
Version 3.1.0 adds support for seamless pagination.

Read about implementing Pagination effortlessly in the [Pagination Wiki](https://github.com/shyambhat/InstagramKit/wiki/Pagination).


##Installation


Getting started is easy. Just include the files from the directory 'InstagramKit' into your project and you'll be up and running. 

##### Cocoapods Podfile:
```ruby
pod 'InstagramKit', '3.1.1'
```
#### Instagram Developer Registration
Head over to http://instagram.com/developer/clients/manage/ to register your app with Instagram and insert the right credentials in InstagramKit.plist. 
If you prefer the Info.plist for all your app settings, you can include these keys in directly in your info.plist file.



## Demo

Download and run the Demo Project to understand how the engine is intended to be used. 

<img src='https://raw2.github.com/shyambhat/InstagramKit/master/InstagramKitDemo/Instagramkit_demo.png' alt='Screenshot' width=310.5 height=625.5 />



### Contributions?

Glad you asked. Check out the [open Issues](https://github.com/shyambhat/InstagramKit/issues?state=open) and jump right in.


Questions? 
The [Instagram API Documentation](http://instagram.com/developer/endpoints/) is your definitive source of information in case something goes wrong. Please make sure you've read up the document thoroughly before posting issues.

==================


InstagramKit uses the public Instagram API and is not affiliated with either Instagram or Facebook.

If you're using InstagramKit in your app or intend to, I'd be happy to hear from you. 

~ [@bhatthead](https://twitter.com/bhatthead)
