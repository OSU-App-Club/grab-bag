//
//  ViewController.m
//  SpotifySample
//
//  Created by Chris Vanderschuere on 1/27/14.
//  Copyright (c) 2014 OSU App Club. All rights reserved.
//

#import "ViewController.h"
#import "appkey.h"

@interface ViewController ()

@property (strong) SPPlaybackManager *playbackManager;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
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
    
    
    //Create playback manager
    self.playbackManager = [[SPPlaybackManager alloc] initWithPlaybackSession:[SPSession sharedSession]];
    
    
    //Ask user to login
    SPLoginViewController *loginController = [SPLoginViewController loginControllerForSession:[SPSession sharedSession]];
    loginController.allowsCancel = NO;
    
    //Present somehow (ie modally from view controller)
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self presentViewController:loginController animated:YES completion:^{
            NSLog(@"Login presented");
        }];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SPSessionDelegate
-(void)session:(SPSession *)aSession didEncounterNetworkError:(NSError *)error{
    
}

-(void)session:(SPSession *)aSession didLogMessage:(NSString *)aMessage{
    
}

-(void)sessionDidChangeMetadata:(SPSession *)aSession{
    
}

-(void)session:(SPSession *)aSession recievedMessageForUser:(NSString *)aMessage{
    
}

#pragma mark - Login stuff
-(UIViewController *)viewControllerToPresentLoginViewForSession:(SPSession *)aSession {
    return self;
}

-(void)sessionDidLoginSuccessfully:(SPSession *)aSession; {
    // Invoked by SPSession after a successful login.
    
    NSLog(@"Logged in successfully");
    
    //Probably a good time to start a song
    
    //Play track from URI
    NSURL *trackURL = [NSURL URLWithString:@"spotify:track:0sR5t999JSjMxn3sFkf6E3"];
    [[SPSession sharedSession] trackForURL:trackURL callback:^(SPTrack *track) {
        [SPAsyncLoading waitUntilLoaded:track timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *tracks, NSArray *notLoadedTracks) {
            [self.playbackManager playTrack:track callback:^(NSError *error) {
                NSLog(@"Song in playing");
            }];
        }];
    }];

}

-(void)session:(SPSession *)aSession didFailToLoginWithError:(NSError *)error; {
    // Invoked by SPSession after a failed login.
    
        NSLog(@"Login error: %@",error);
}

-(void)sessionDidLogOut:(SPSession *)aSession {
    //Maybe show login again
    
}

@end
