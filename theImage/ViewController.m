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
#import "AFNetworking.h"
//#import "AFHTTPClient.h"
#import "UIActivityIndicatorView+AFNetworking.h"
#import "UIAlertView+AFNetworking.h"

//#import <AFNetworking/ASAPIManager.h>

#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import <AFNetworking/AFHTTPRequestOperation.h>
#import <AFNetworking/AFURLResponseSerialization.h>
#import <AFNetworking/AFHTTPSessionManager.h>

#import <FacebookSDK/FacebookSDK.h>

@interface ViewController() // <ViewControllerDetailDelegate>

@end

@implementation ViewController

    CLLocationManager *locationManager;
    static int playerID = 0;
    static NSString* facebookPlayerID;

+ (int) playerID{
    return playerID;
}

+ (NSString *)facebookID{
    return  facebookPlayerID;
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
    
    FBLoginView *loginView = [[FBLoginView alloc] init];
    // Align the button in the center horizontally
    loginView.readPermissions = @[@"basic_info", @"email", @"user_likes"];
    loginView.delegate = self;
    loginView.frame = CGRectOffset(loginView.frame, (self.view.center.x - (loginView.frame.size.width / 2)), 5);
    [self.view addSubview:loginView];
    
    //[[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    locationManager = [[CLLocationManager alloc] init];
    
    /*
    playerOnline.text = @"Player Online";
    playerName.text = @"ANDREW BUTTIGIEG!!!!";
    playerID = 1; //make it andrew...
    */
	// Do any additional setup after loading the view, typically from a nib.
}

// This method will be called when the user information has been fetched
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    
    
    /*
     the guy logged in on facebook!!
     */
    
    facebookPlayerID = user.id;
    playerName.text = user.name;
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://newfootballers.com/login_user.php"]];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [request setHTTPBody:[[NSString stringWithFormat:@"fb=%@", facebookPlayerID]dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            //[self.delegate fetchingGroupsFailedWithError:error];
        } else {
            //[self.delegate receivedGroupsJSON:data];
            NSError *localError = nil;
            NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
            
            NSMutableArray *groups = [[NSMutableArray alloc] init];
            NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                                        options:0
                                                                          error:&error];
            dispatch_async(dispatch_get_main_queue(), ^{
                for(NSDictionary *dictionary in jsonArray)
                {
                    NSLog(@"Data Dictionary is : %@",dictionary);
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
}


- (IBAction)uploadImage:(id)sender {
    NSData *imageData = UIImageJPEGRepresentation(self.toUpload.image, 0.2);     //change Image to NSData
    NSString *baseurl = @"http://newfootballers.com/upload_image.php";
    NSDictionary *parameters = @{@"u": @"1", @"t": @"having fun!", @"n": @"Winning!"};
    
    // 1. Create `AFHTTPRequestSerializer` which will create your request.
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    
    // 2. Create an `NSMutableURLRequest`.
    NSMutableURLRequest *request =
    [serializer multipartFormRequestWithMethod:@"POST" URLString:baseurl
                                    parameters:parameters
                     constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                         [formData appendPartWithFileData:imageData
                                                     name:@"attachment"
                                                 fileName:@"myimage.jpg"
                                                 mimeType:@"image/jpeg"];
                     }];
    
    // 3. Create and use `AFHTTPRequestOperationManager` to create an `AFHTTPRequestOperation` from the `NSMutableURLRequest` that we just created.
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestOperation *operation =
    [manager HTTPRequestOperationWithRequest:request
                                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                         NSLog(@"Success %@", responseObject);
                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         NSLog(@"Failure %@", error.description);
                                     }];
    
    // 4. Set the progress block of the operation.
    [operation setUploadProgressBlock:^(NSUInteger __unused bytesWritten,
                                        long long totalBytesWritten,
                                        long long totalBytesExpectedToWrite) {
        NSLog(@"Wrote %lld/%lld", totalBytesWritten, totalBytesExpectedToWrite);
    }];
    
    // 5. Begin!
    [operation start];
    
    if (imageData != nil && 1 == 2)
    {
        
        
        //NSData *data = [NSData dataWithContentsOfFile:filePath];
        NSMutableString *urlString = [[NSMutableString alloc] initWithFormat:@"name=thefile&filename="];
        [urlString appendFormat:@"%@", imageData];
        NSData *postData = [urlString dataUsingEncoding:NSASCIIStringEncoding
                                   allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        
        NSURL *url = [NSURL URLWithString:baseurl];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
        [urlRequest setHTTPMethod: @"POST"];
        [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [urlRequest setValue:@"application/x-www-form-urlencoded"
          forHTTPHeaderField:@"Content-Type"];
        
        [urlRequest setHTTPBody:postData];
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        NSLog(returnString);
        
        NSLog(@"Started!");
    }
    
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
