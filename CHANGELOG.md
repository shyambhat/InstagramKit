# Change Log
All notable changes to this project will be documented in this file.
`InstagramKit` adheres to [Semantic Versioning](http://semver.org/).

---
## [4.1] - 2018-06-20

- [#280](https://github.com/shyambhat/InstagramKit/pull/280) Avoid crash when AFNetworkingOperationFailingURLResponseDataErrorKey is not present. By [@mercadodiego](https://github.com/mercadodiego)
- [#255](https://github.com/shyambhat/InstagramKit/pull/255) InstagramMedia get comments count returns zero. By [@vigneshuvi](https://github.com/vigneshuvi)
- [#221](https://github.com/shyambhat/InstagramKit/pull/221) Removed deprecated Popular Media endpoints. By [@shyambhat](https://github.com/shyambhat)


## [4.0] - 2018-06-03
- [#221](https://github.com/shyambhat/InstagramKit/pull/221) Support for Instagram Platform updates.
- [#254](https://github.com/shyambhat/InstagramKit/pull/254) Up to date with modify APIs from Instagram. By [@ht22pt](https://github.com/ht22pt) 
- [#218]( https://github.com/shyambhat/InstagramKit/pull/218) Update + new functionalities for InstagramKit-Example. By [@marcgovi](https://github.com/marcgovi)
- [#273] Fix example project. By [@ricsantos](https://github.com/ricsantos) 
- [#239](https://github.com/shyambhat/InstagramKit/issues/239) Implemented issue. By [@afilipowicz](https://github.com/afilipowicz)
- [#227](https://github.com/shyambhat/InstagramKit/pull/227) Add `NS_SWIFT_NOTHROW` for disabling error throw handling in swift.  By [@derek-chim](https://github.com/derek-chim)

## [3.8.2] - 2018-06-03
- [#278](https://github.com/shyambhat/InstagramKit/pull/278) Not null checks during initialization across all model objects. By [@shyambhat](https://github.com/shyambhat)

## [3.8.1] - 2018-04-24
- [#278](https://github.com/shyambhat/InstagramKit/pull/278) Fixed crash for missing full_name in InstagramUser. By [@stremsdoerfer](https://github.com/stremsdoerfer)

## [3.8] - 2016-03-20
- [#201](https://github.com/shyambhat/InstagramKit/pull/201) Fixed issue [#194](https://github.com/shyambhat/InstagramKit/pull/194): New Permissions For Instagram. By [@zzdjk6](https://github.com/zzdjk6)
- [#203](https://github.com/shyambhat/InstagramKit/pull/203) Fixed issue with likes count By [@mgarciam](https://github.com/mgarciam)
- [#211](https://github.com/shyambhat/InstagramKit/pull/211) Added support for `app://` formatted custom redirect URLs. By [@gugges](https://github.com/gugges)
- [#215](https://github.com/shyambhat/InstagramKit/pull/215) Added support for AFNetworking 3.0 By [@Beniamiiin](https://github.com/Beniamiiin)
- More Unit tests.

## [3.7] - 2015-12-09
- Complete Swift compatibility.
- [#179](https://github.com/shyambhat/InstagramKit/pull/179) Add Nullability and Lightweight Generics for Xcode 7. By [@Adlai-Holler](https://github.com/Adlai-Holler)
- Unit tests for Media and User methods in InstagramEngine. By [@shyambhat](https://github.com/shyambhat)
- [#177](https://github.com/shyambhat/InstagramKit/pull/177) Fix issue with pagination. Avoid percent-encoding twice. By [@snoonz](https://github.com/snoonz)

#### Added
- #188 ```InstagramUser loadDetailsWithCompletion:``` to fetch User details and update the same user object.

## [3.6.9] - 2015-10-19

#### Added
- Xcode 7 changes to Project file.
- Added CHANGELOG.md

#### Changed
- `-getMediaAtLocation: count: maxId: withSuccess: failure:` changed to `-getMediaAtLocation: count: maxId: distance: withSuccess: failure:`
- #167 Typo fixed `-authorizarionURL` to `authorizationURL`. By @natan.

#### Fixed
- #146 Checks for media URLs in initializing InstagramMedia objects.
- #148 Fix Token Get in Authorisation scopes. By @DanTakagaki.
- #164 InstagramModel copyWithZone updated to allocate correct type of object. By @urklc.
- #165 Parameter Count must be larger than zero. Fixes #150. By @shyambhat


## [3.6.8] - 2015-08-26
Hotfix Version

- Typo fix #72 
- Pull Request #145 by @trauzti

## [3.6.7] - 2015-08-26

- Pull Request #144 by @abury

## [3.6.6] - 2015-08-21

#### Additions : 
- Persisting access token using **UICKeyChainStore**. UICKeyChainStore is added as an optional sub-spec.
- Discontinued support for iOS 6, to comply with AFNetworking's compatible SDKs. 
- Added `- authorizarionURL` helper method to InstagramEngine to generate Authorization URL with basic permissions.

#### Changes : 
- `- extractValidAccessTokenFromURL` renamed to `- receivedValidAccessTokenFromURL`
- `- getUserDetails: withSuccess: failure:` accepts a string value for userId to maintain consistency.

#### Fixes : 
- Call super encode/decode on subclasses of InstagramModel to keep ID property persisted 
  Implemented by @natan in #140
