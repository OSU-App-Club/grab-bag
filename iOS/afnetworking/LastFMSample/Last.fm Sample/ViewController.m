//
//  ViewController.m
//  Last.fm Sample
//
//  Created by Chris Vanderschuere on 2/3/14.
//  Copyright (c) 2014 CDVConcepts. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>


@interface ViewController ()

@property (nonatomic,strong) NSArray *trackArray;
@property (nonatomic,strong) NSOperationQueue *backgroundQueue;

@end

@implementation ViewController

- (void) setTrackArray:(NSArray *)trackArray{
    _trackArray = trackArray;
    
    //Reload the collection view on the main thread any time trackArray is updated
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.collectionView reloadData];
    }];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    #error Enter your Last.FM API key here
    NSString *apiKey = @"XXXXXXXXXXXXXXX"; //Last.fm API key
    NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ws.audioscrobbler.com/2.0/?method=chart.gettoptracks&api_key=%@&format=json",apiKey]]];
    [req setHTTPMethod:@"GET"];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    //Setup blocks that will be called after request finishes
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
     //This happens on SUCCESS
        
        //responseObject will be a NSDictionary because of JSON parser
        self.trackArray = (NSArray* )[[responseObject objectForKey:@"tracks"] objectForKey:@"track"];
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //This happend on FAILURE
        NSLog(@"Error: %@",error);
    }];
    
    //Create on background queue so is async
    self.backgroundQueue = [[NSOperationQueue alloc] init];
    [self.backgroundQueue addOperation:operation];
    
}


#pragma mark - UICollectionView Stuff
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.trackArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"trackCell" forIndexPath:indexPath];
    
    NSDictionary *track = [self.trackArray objectAtIndex:indexPath.item];
    
    //Do stuff to the cell to customize it
    
    //Set name label
    UILabel *nameLabel = (UILabel *)[self.collectionView viewWithTag:10];
    nameLabel.text = [track objectForKey:@"name"];
    
    //Set imageview
    UIImageView *albumArt = (UIImageView*)[self.collectionView viewWithTag:11];
    NSString *artworkURL = [[track objectForKey:@"image"][2] objectForKey:@"#text"];
    [albumArt setImageWithURL:[NSURL URLWithString:artworkURL]];
    
    return cell;
}
@end
