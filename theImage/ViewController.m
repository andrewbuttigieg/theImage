//
//  ViewController.m
//  theImage
//
//  Created by Andrew Buttigieg on 1/1/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import "ViewController.h"
#import "ViewControllerDetail.h"
#import "FindPlayerController.h"
#import "AFHTTPRequestOperationManager.h"
//#import "AFNetworking.h"
#import "UIActivityIndicatorView+AFNetworking.h"
#import "UIAlertView+AFNetworking.h"
#import <FacebookSDK/FacebookSDK.h>
#import "StartController.h"
#import "LogMeIn.h"

#import "VideoController.h"

@interface ViewControllerxxxx() //  <ViewControllerDetailDelegate>

@end

@implementation ViewControllerxxxx


    static int playerID = 0;
    static NSString* facebookPlayerID;

+ (int) playerID{
    return playerID;
}

/*
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://newfootballers.com/get_me.php"]];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [request setHTTPMethod:@"POST"];
  
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
        } else {
            NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                                        options:0
                                                                          error:&error];
            NSLog(@"Data Dictionary is : %@", jsonArray);
            dispatch_async(dispatch_get_main_queue(), ^{
                for(NSDictionary *dictionary in jsonArray)
                {
                    NSString *imageURL = [dictionary objectForKey:@"PhotoURL"];
                    
                    playerID = [[dictionary objectForKey:@"UserID"] intValue];
                    
                    if ([imageURL length] > 5){
                        self.toUpload.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
                    }
                }
            });
        }
    }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)logoPressedTwo:(id)sender {
    NSLog(@"Pressed!");
}

- (IBAction)getHTTP:(id)sender {
    
  //  NSLog(@"Pressed!");
    NSURL *url = [NSURL URLWithString:@"http://techreport.com/news/25864/amd-sheds-more-light-on-kaveri-announces-new-mobile-radeons"];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url
                                
                                                cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                            timeoutInterval:30];
    // Fetch the JSON response
    NSData *urlData;
    NSURLResponse *response;
    NSError *error;
    
    // Make synchronous request
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest
                                    returningResponse:&response
                                                error:&error];
    
    // Construct a String around the Data from the response
    //NSString *http = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
}

- (IBAction)logOut:(id)sender {
    if ([LogMeIn logout]){
        
        if (FBSession.activeSession.isOpen)
        {
            [FBSession.activeSession closeAndClearTokenInformation];
        }
        
        
        NSString * storyboardName = @"Main_iPhone";
        NSString * viewControllerID = @"StartController";
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
        StartController * controller = (StartController *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
        
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (IBAction)open:(id)sender {
    NSString * storyboardName = @"Main_iPhone";
    NSString * viewControllerID = @"VideoController";
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    VideoController * controller = (VideoController *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
    //controller.chattingToID = [o intValue];
    //controller.name = name;
    controller.playerID = playerID;
    [self.navigationController pushViewController:controller animated:YES];
}



- (IBAction)logoPressed:(id)sender {
    
     
   NSLog(@"Pressed!");
   
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	/*if ([segue.identifier isEqualToString:@"AddPlayer"])
	{
		UINavigationController *navigationController =
        segue.destinationViewController;
		ViewControllerDetail
        *ViewControllerDetail = [[navigationController viewControllers]
objectAtIndex:0];
		ViewControllerDetail.delegate = self;
	}
    
    if ([segue.identifier isEqualToString:@"discover"])
	{
		UINavigationController *navigationController =
        segue.destinationViewController;
		FindPlayerController
        *FindPlayerController = [[navigationController viewControllers]
                                 objectAtIndex:0];
		//FindPlayerController.delegate = self;
	}*/
}

#pragma mark - ViewControllerDetailDelegate

- (void)playerDetailsViewControllerDidSave:
(ViewControllerDetail *)controller
{
    NSLog(@"End me");
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addItemViewController:
(ViewControllerDetail *)controller didFinishEnteringItem:    (NSString *)item
{
    //using delegate method, get data back from second page view controller and set it to property declared in here
    NSLog(@"This was returned from secondPageViewController: %@",item);
    self.returnedItem=item;
    
    //add item to array here and call reload
}

@end
