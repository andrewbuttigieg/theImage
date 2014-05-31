//
//  MainVC.m
//  theImage
//
//  Created by Andrew Buttigieg on 3/18/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import "MainVC.h"
#import <FacebookSDK/FacebookSDK.h>
#import "StartController.h"
#import "LogMeIn.h"
#import "PlayerController.h"

@interface MainVC ()

@end

@implementation MainVC
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;

-(void)leftMenuWillOpen
{
    //something
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://newfootballers.com/get_me.php"]];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
        } else {
            //NSError *localError = nil;
            NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                                        options:0
                                                                          error:&error];
            NSLog(@"Data Dictionary is : %@", jsonArray);
            dispatch_async(dispatch_get_main_queue(), ^{
                for(NSDictionary *dictionary in jsonArray)
                {
                    //NSString *imageURL = [dictionary objectForKey:@"PhotoURL"];
                    
                    NSInteger requestCount = [[dictionary objectForKey:@"ConnectionRequestCount"] integerValue];
                    
                    NSInteger friendCount = [[dictionary objectForKey:@"UnreadMessageCount"] integerValue];
                    
                    [self.delegate MainVCController:self countUpdate :friendCount :requestCount];

                }
            });
        }
    }];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

   // tableView.separatorColor = [UIColor clearColor];
    self.slideMenuDelegate = self;
    
    [self aTime];
    [NSTimer scheduledTimerWithTimeInterval:600 target:self selector:@selector(aTime) userInfo:nil repeats:YES];
}

-(void)aTime
{
    if (PlayerController.useLocalisation){
        locationManager = [[CLLocationManager alloc] init];
        geocoder = [[CLGeocoder alloc] init];
    
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [locationManager startUpdatingLocation];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)segueIdentifierForIndexPathInLeftMenu:(NSIndexPath *)indexPath
{
    NSString *identifier = @"";
    switch (indexPath.row) {
        case 0:
            identifier = @"firstRow";
            break;
        case 1:
            identifier = @"firstRow";
            break;
        case 2:
            identifier = @"secondRow";
            break;
        case 3:
            identifier = @"thirdRow";
            break;
        case 4:
            identifier = @"forthRow";
            break;
        case 5:
            identifier = @"fifthRow";
            break;
            /*
        case 6:
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
            break;*/
        case 6:
            identifier = @"sixthRow";
            break;
        case 7:
            identifier = @"allVideoRow";
            break;
    }
    
    return identifier;
}

- (NSString *)segueIdentifierForIndexPathInRightMenu:(NSIndexPath *)indexPath
{
    NSString *identifier = @"";
    switch (indexPath.row) {
        case 0:
            identifier = @"firstRow";
            break;
        case 1:
            identifier = @"secondRow";
            break;
    }
    
    return identifier;
}


- (CGFloat)leftMenuWidth
{
    return 250;
}

- (CGFloat)rightMenuWidth
{
    return 180;
}

- (void)configureLeftMenuButton:(UIButton *)button
{
    CGRect frame = button.frame;
    frame = CGRectMake(0, 0, 25, 13);
    button.frame = frame;
    button.backgroundColor = [UIColor clearColor];
    [button setImage:[UIImage imageNamed:@"simpleMenuButton" ] forState:UIControlStateNormal];
}

- (void)configureRightMenuButton:(UIButton *)button
{
    CGRect frame = button.frame;
    frame = CGRectMake(0, 0, 25, 13);
    button.frame = frame;
    button.backgroundColor = [UIColor clearColor];
    [button setImage:[UIImage imageNamed:@"simpleMenuButton"] forState:UIControlStateNormal];
}

- (void) configureSlideLayer:(CALayer *)layer
{
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOpacity = 1;
    layer.shadowOffset = CGSizeMake(0, 0);
    layer.shadowRadius = 5;
    layer.masksToBounds = NO;
    layer.shadowPath =[UIBezierPath bezierPathWithRect:self.view.layer.bounds].CGPath;
}

- (AMPrimaryMenu)primaryMenu
{
    return AMPrimaryMenuLeft;
}


// Enabling Deepnes on left menu
- (BOOL)deepnessForLeftMenu
{
    return YES;
}

// Enabling Deepnes on left menu




- (BOOL)deepnessForRightMenu
{
    return YES;
}

// Enabling darkness while left menu is opening
- (CGFloat)maxDarknessWhileLeftMenu
{
    return 0.5;
}

// Enabling darkness while right menu is opening
- (CGFloat)maxDarknessWhileRightMenu
{
    return 0.5;
}






#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    /*UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];*/
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    NSString *l1;
    NSString *l2;
    if (currentLocation != nil) {
        l1 = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        l2 = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    }
    
    [locationManager stopUpdatingLocation];
    // Reverse Geocoding
    NSLog(@"Resolving the Address");
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            /*
            addressLabel.text = [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@",
                                 placemark.subThoroughfare, placemark.thoroughfare,
                                 placemark.postalCode, placemark.locality,
                                 placemark.administrativeArea,
                                 placemark.country];
            addressLabel.numberOfLines = 5;
            */
            NSString *a1 = [NSString stringWithFormat:@"%@ %@", placemark.subThoroughfare, placemark.thoroughfare];
            NSString *a2 = [NSString stringWithFormat:@"%@", placemark.locality];
            NSString *a3 = [NSString stringWithFormat:@"%@", placemark.administrativeArea];
            NSString *p = [NSString stringWithFormat:@"%@", placemark.postalCode];
            NSString *c = [NSString stringWithFormat:@"%@", placemark.country];
            ////
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://newfootballers.com/update_user_location.php/"]];
            [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
            
            [request setHTTPBody:[[NSString stringWithFormat:@"l1=%@&l2=%@&a1=%@&a2=%@&a3=%@&c=%@&p=%@",
                                   l1, l2, a1, a2, a3, c, p]dataUsingEncoding:NSUTF8StringEncoding]];
            [request setHTTPMethod:@"POST"];
            [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init]
             //returningResponse:&response
                                   completionHandler:^(NSURLResponse *response,
                                                       NSData *data,
                                                       NSError *error) {
                                       
                                       if (error) {
                                           //[self.delegate fetchingGroupsFailedWithError:error];
                                       }
                                       else {
                                           /*NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                            options:0
                                            error:&error];
                                            for(NSDictionary *dictionary in jsonArray)
                                            {
                                            NSString *returned = [jsonArray[0] objectForKey:@"value"];
                                            }*/
                                       }
                                   }];
            ////
            
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
    
    
}




@end
