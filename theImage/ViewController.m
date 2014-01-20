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

@interface ViewController() // <ViewControllerDetailDelegate>

@end

@implementation ViewController

    CLLocationManager *locationManager;
    static int playerID = 0;

+ (int) playerID{
    return playerID;
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    locationManager = [[CLLocationManager alloc] init];
    
    playerOnline.text = @"Player Online";
    playerName.text = @"ANDREW BUTTIGIEG";
    playerID = 32;
    
    
    // Create Login View so that the app will be granted "status_update" permission.
/*    FBLoginView *loginView = [[FBLoginView alloc] init];
    [self.view addSubview:loginView];*/
    
  /*
    NSURL *url = [NSURL URLWithString:@"http://www.youtube.com/watch?v=fDXWW5vX-64"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
*/
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)logoPressedTwo:(id)sender {
    NSLog(@"Pressed!");
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
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
    NSString *http = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
    
    /*
     [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
     
     if (error) {
     [self.delegate fetchingGroupsFailedWithError:error];
     } else {
     [self.delegate receivedGroupsJSON:data];
     }
     }];
     
     */

}

- (IBAction)logoPressed:(id)sender {
    /*
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
     */
   NSLog(@"Pressed!");
   /* UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Good one!"
message:@"You hit the logo"
delegate:self
cancelButtonTitle:@"Go Away"
otherButtonTitles:nil];
    [alert show];*/
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"AddPlayer"])
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
	}
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

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        xLok.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        yLok.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    }
}

@end
