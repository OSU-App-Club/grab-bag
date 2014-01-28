#Cocoapods
CocoaPods is the dependency manager for Objective-C projects. It has thousands of libraries and can help you scale your projects elegantly.

More information at [cocoapods.org](http://cocoapods.org/)

##Install
	$ sudo gem install cocoapods

##Get Started
*	Create file called `Podfile` in root directory of project
*	Add pod you are interested in: example `pod 'CocoaLibSpotify', '~> 2.4.5'`
*	`pod install`
*	Use .xcworkspace instead of xcproj
*	Import dependencies: example `#import "CocoaLibSpotify.h"`
