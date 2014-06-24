//
//  StartController.m
//  theImage
//
//  Created by Andrew Buttigieg on 3/5/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import "AppDelegate.h"
#import "StartController.h"
#import "KeychainItemWrapper.h"
#import "JNKeychain.h"
#import "LogMeIn.h"
#import "PlayerController.h"
#import "MainVC.h"
#import <FacebookSDK/FacebookSDK.h>
#import "UIViewController+AMSlideMenu.h"

@interface StartController ()

@end

@implementation StartController

static int messageCounter;

+ (int) messageCounter{
    return messageCounter;
}

bool loggedIn = false;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void) viewWillAppear:(BOOL)animated
{
//    self.delegate.currentView = @"Start";

    self.mainSlideMenu.panGesture.enabled = NO;
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.currentView = @"start";
    
    [self.moviePlayer play];
    [super viewWillAppear:animated];
    //self.navigationController.toolbarHidden = YES;
    [self.navigationController setNavigationBarHidden:YES];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self.moviePlayer pause];
    [super viewWillDisappear:animated];
    self.mainSlideMenu.panGesture.enabled = YES;
    //self.navigationController.toolbarHidden = NO;
    [self.navigationController setNavigationBarHidden:NO];
    [super viewWillDisappear:animated];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CurrentViewController" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self, @"lastViewController", nil]];
}

- (void)applicationDidBecomeActive:(NSNotification *) notification
{
    [self.moviePlayer play];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"%@", self.navigationController.viewControllers);
    
    loggedIn = false;
    
    
    /*
    FBLoginView *loginView = [[FBLoginView alloc] init];
    //loginView.readPermissions = @[@"user_birthday", @"basic_info", @"email", @"public_profile", @"user_friends", @"user_photos"];
    //loginView.readPermissions = @[@"email", @"public_profile", @"user_friends"];
    
    loginView.delegate = self;
    loginView.frame = CGRectOffset(loginView.frame, (self.view.center.x - (loginView.frame.size.width / 2)), 100);
    loginView.hidden = false;
    [self.view addSubview:loginView];
    */
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    NSString*thePath=[[NSBundle mainBundle] pathForResource:@"intro" ofType:@"mp4"];
    NSURL*theurl=[NSURL fileURLWithPath:thePath];
    
    self.moviePlayer=[[MPMoviePlayerController alloc] initWithContentURL:theurl];
    self.moviePlayer.controlStyle = MPMovieControlStyleNone;
    [self.moviePlayer.view setFrame:CGRectMake(0, 0, 320, (1138 / 2))];
    [self.moviePlayer prepareToPlay];
    [self.moviePlayer setRepeatMode:YES];
    [self.moviePlayer setShouldAutoplay:NO];
    [self.back addSubview:self.moviePlayer.view];
    
    NSString *keyLogin = @"login";
    NSString *keyPwd = @"pwd";
    NSString *login = [JNKeychain loadValueForKey:keyLogin];
    NSString *pwd = [JNKeychain loadValueForKey:keyPwd];
    
    if (login != nil && pwd != nil){
        if ([LogMeIn login:login :pwd]){
            /*
            NSString * storyboardName = @"Main_iPhone";
            NSString * viewControllerID = @"PlayerController";
            UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
            PlayerController * controller = (PlayerController *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
            */
            
            [self GoToPlayer];
        }
    }
    else{
        [self.moviePlayer play];
    }
    
     //[keychain setObject:password forKey:(__bridge id)(kSecValueData)];
    
	// Do any additional setup after loading the view.
}


- (void)facebookSessionStateChanged:(FBSession *)session state:(FBSessionState)state error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen:
            // handle successful login here
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            
            if (error) {
                // handle error here, for example by showing an alert to the user
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not login with Facebook"
                                                                message:@"Facebook login failed. Please check your Facebook settings on your phone."
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
            break;
        default:
            break;
    }
}

// Handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    
    NSLog(@"FBLoginView encountered an error=%@", error);
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures that happen outside of the app
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}


// This method will be called when the user information has been fetched
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    
    if (!self.isViewLoaded || !self.view.window) {
        return;
    }
    
    if (self.messageCounter >0 || loggedIn)
        return;
    else
    {
        self.messageCounter++;
        NSString *facebookPlayerID = user.id;
        //playerName.text = user.name;
        
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://newfootballers.com/login_player_fb.php"]];
        [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
        [request setHTTPBody:[[NSString stringWithFormat:@"fb=%@", facebookPlayerID]dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPMethod:@"POST"];
        
        
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            
            if (error) {
                //[self.delegate fetchingGroupsFailedWithError:error];
            } else {
                //[self.delegate receivedGroupsJSON:data];
                NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                                            options:0
                                                                              error:&error];
                dispatch_async(dispatch_get_main_queue(), ^{
                    for(NSDictionary *dictionary in jsonArray)
                    {
                        NSLog(@"Data Dictionary is : %@",dictionary);
                        NSString *returned = [jsonArray[0] objectForKey:@"value"];
                        int accepted = [[jsonArray[0] objectForKey:@"accepted"] intValue];
                        
                        if (accepted == 0){
                            loggedIn = false;
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"PlayerCV"
                                                                            message:[NSString stringWithFormat:@"%@",returned]
                                                                           delegate:self
                                                                  cancelButtonTitle:@"Ok"
                                                                  otherButtonTitles:nil];
                            [alert show];
                        }
                        else{
                            
                            AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                            if (appDelegate.theDeviceToken != nil && ![appDelegate.theDeviceToken isEqual: [NSNull null]]){
                                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://newfootballers.com/update_user_iospushnotificationid.php/"]];
                                [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
                                [request setHTTPBody:[[NSString stringWithFormat:@"iospushnotificationid=%@", appDelegate.theDeviceToken]dataUsingEncoding:NSUTF8StringEncoding]];
                                [request setHTTPMethod:@"POST"];
                                
                                [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                    
                                    if (error) {
                                        //[self.delegate fetchingGroupsFailedWithError:error];
                                    } else {
                                    }
                                }];
                            }

                            //logged in by fb
                            [self GoToPlayer];
                        }
                    }
                    [self setMessageCounter:0];
                });
            }
        }];
    }
}

-(void)GoToPlayer{
    loggedIn = true;
    [self.back removeFromSuperview];
    [self.moviePlayer stop];
    [self.moviePlayer setContentURL:nil];
    [self.moviePlayer.view removeFromSuperview];
    
    NSString * storyboardName = @"Main_iPhone";
    NSString * viewControllerID = @"Main";
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    MainVC * controller = (MainVC *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (loggedIn){
        self.navigationController.navigationBarHidden = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}


@end
