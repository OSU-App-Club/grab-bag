#Spotify (v2.4.5)
A Cocoa wrapper for libspotify.

#Basics:

##SPSession	
###Implementation
	NSError *error = nil;
	[SPSession initializeSharedSessionWithApplicationKey:[NSData dataWithBytes:&g_appkey length:g_appkey_size]
										   userAgent:@"com.osu-app-club.sample"
									   loadingPolicy:SPAsyncLoadingManual
											   error:&error];
	if (error != nil) {
		NSLog(@"CocoaLibSpotify init failed: %@", error);
		abort();
	}
	
	//Register for delegate methods
	[[SPSession sharedSession] setDelegate:self];	
###Callbacks
Various callbacks for SPSession as defined in [documentation](http://cocoadocs.org/docsets/CocoaLibSpotify/2.4.5/Protocols/SPSessionDelegate.html)

	-(void)session:(SPSession *)aSession didEncounterNetworkError:(NSError *)error{
	
	}

	-(void)session:(SPSession *)aSession didLogMessage:(NSString *)aMessage{
	
	}

	-(void)sessionDidChangeMetadata:(SPSession *)aSession{
	
	}

	-(void)session:(SPSession *)aSession recievedMessageForUser:(NSString *)aMessage{
	
	}

##PlaybackManager
###Create
	SPPlaybackManager *aPlaybackManager = [[SPPlaybackManager alloc] initWithPlaybackSession:[SPSession sharedSession]]
###Controls
	//Play track from URI 
	[[SPSession sharedSession] trackForURL:trackURL callback:^(SPTrack *track) {
		[SPAsyncLoading waitUntilLoaded:track timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *tracks, NSArray *notLoadedTracks) {
			[aPlaybackManager playTrack:track callback:^(NSError *error) {
			
			}];
		}]
	}];
	
	//Seek on track
	[aPlaybackManager seekToTrackPosition:aTimeInterval];
	
	//Set Volume
	[aPlaybackManager setVolume:aFloatValue]; //0.0 to 1.0
	

##Login/Logout
###Implementation
	SPLoginViewController *controller = [SPLoginViewController loginControllerForSession:[SPSession sharedSession]];
	controller.allowsCancel = NO;
	
	//Present somehow (ie modally from view controller)
	[self presentModalViewController:controller animated:YES];
	
	//Logout
	[[SPSession sharedSession] logout:^{
		//Do something after logout completes
	}];
	
###Callbacks
	-(UIViewController *)viewControllerToPresentLoginViewForSession:(SPSession *)aSession {
		return viewControllerThatPresentedLogin;
	}

	-(void)sessionDidLoginSuccessfully:(SPSession *)aSession; {
		// Invoked by SPSession after a successful login.
	}

	-(void)session:(SPSession *)aSession didFailToLoginWithError:(NSError *)error; {
		// Invoked by SPSession after a failed login.
	}

	-(void)sessionDidLogOut:(SPSession *)aSession {
		//Maybe show login again
	}
##Track Information
Useful information in SPTrack
More reference found in the [documentation](http://cocoadocs.org/docsets/CocoaLibSpotify/2.4.5/Classes/SPTrack.html)

	//Artists
	currentTrack.artists
	
	//Cover Art
	currentTrack.album.cover.image
	
	//Name
	currentTrack.name

#Gotchas
 *	Including appkey.h (API key information found on libspotify website)	

