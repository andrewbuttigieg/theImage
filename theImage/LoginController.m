
//
//  LoginController.m
//  theImage
//
//  Created by Andrew Buttigieg on 3/5/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import "LoginController.h"
#import "KeychainItemWrapper.h"
#import "LogMeIn.h"
#import "MainVC.h"
#import <FacebookSDK/FacebookSDK.h>
#import "UIViewController+AMSlideMenu.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"

@interface LoginController () <FBLoginViewDelegate>

@end

@implementation LoginController

static int messageCounter;

+ (int) messageCounter{
    return messageCounter;
}

CGSize keyboardSize;
bool movedHere = false;

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
    [super viewWillAppear:animated];
    [self.moviePlayer play];
    self.mainSlideMenu.panGesture.enabled = NO;
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.moviePlayer pause];
    self.mainSlideMenu.panGesture.enabled = YES;
    self.messageCounter = 0;
}

- (void)applicationDidBecomeActive:(NSNotification *) notification
{
    [self.moviePlayer play];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Login";
    
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
    [self.moviePlayer play];
    
    self.email.delegate = self;
    self.password.delegate = self;
    /*
    
    FBLoginView *loginView = [[FBLoginView alloc] init];
    // Align the button in the center horizontally
    //loginView.readPermissions = @[@"user_birthday", @"basic_info", @"email", @"public_profile", @"user_friends", @"user_photos"];

    //loginView.readPermissions = @[@"email", @"public_profile", @"user_friends"];
    
    loginView.delegate = self;
    loginView.frame = CGRectOffset(loginView.frame, (self.view.center.x - (loginView.frame.size.width / 2)), 20);
    [self.scrollViewLogin addSubview:loginView];
    
    self.scrollViewLogin.contentSize = CGSizeMake(320, 480);*/
    
    // Create Login View so that the app will be granted "status_update" permission.
    FBLoginView *loginview = [[FBLoginView alloc] init];
    loginview.readPermissions = @[@"email", @"public_profile", @"user_friends", @"publish_actions"];
    
    loginview.frame = CGRectOffset(loginview.frame, 5, 5);
#ifdef __IPHONE_7_0
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        loginview.frame = CGRectOffset(loginview.frame, (self.view.center.x - (loginview.frame.size.width / 2)), 20);
    }
#endif
#endif
#endif
    loginview.delegate = self;
    
    [self.view addSubview:loginview];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

- (IBAction)BackgroundTap:(id)sender
{
    [self.email resignFirstResponder];
    [self.password resignFirstResponder];
}


- (void)viewDidUnload{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)dismissKeyboard:(id)sender
{
    [self.activeTextFieldLogin resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeTextFieldLogin = textField;
    
    [self.moviePlayer pause];
    
    if (movedHere ){
        // Step 3: Scroll the target text field into view.
        CGRect aRect = self.view.frame;
        aRect.size.height -= keyboardSize.height;
        //if (!CGRectContainsPoint(aRect, self.activeTextField.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, self.activeTextFieldLogin.frame.origin.y - (keyboardSize.height-95));
        [self.scrollViewLogin setContentOffset:scrollPoint animated:YES];
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.activeTextFieldLogin = nil;
    [self.moviePlayer play];
    
}

- (void) keyboardWillHide:(NSNotification *)notification {
    movedHere = false;
}

- (void)keyboardWasShown:(NSNotification *)notification
{
    
    // Step 1: Get the size of the keyboard.
    keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // Step 3: Scroll the target text field into view.
    CGRect aRect = self.view.frame;
    aRect.size.height -= keyboardSize.height;
    if (self.activeTextFieldLogin != nil){
        //    NSLog(@"%@", self.activeTextFieldLogin.frame);
    }
    CGRect rect = [[UIApplication sharedApplication] statusBarFrame];
    CGPoint xxx = self.activeTextFieldLogin.frame.origin;
    xxx.y += self.navigationController.navigationBar.frame.size.height + rect.size.height;
    if (!CGRectContainsPoint(aRect, xxx) ) {
        CGPoint scrollPoint = CGPointMake(0.0, self.activeTextFieldLogin.frame.origin.y - (keyboardSize.height-95));
        [self.scrollViewLogin setContentOffset:scrollPoint animated:YES];
    }
    movedHere = true;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)GoToPlayer{
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


- (IBAction)login:(id)sender {
    
    NSString *login = self.email.text;
    NSString *password = self.password.text;
    
    if ([LogMeIn login:login :password]){
        [self GoToPlayer]; //logged in now
    }
}

- (BOOL) validateEmail:(NSString *)emailStr {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}
- (IBAction)forgotPwd:(id)sender {
    
    if ([self validateEmail:self.email.text]){
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://newfootballers.com/reset_password.php/"]];
        [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
        [request setHTTPBody:[[NSString stringWithFormat:@"email=%@",
                               self.email.text
                               ]dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPMethod:@"POST"];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            if (error) {
                NSLog(@"Error:%@", error.localizedDescription);
            }
            else {
                //success
                NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                                            options:0
                                                                              error:&error];
                NSString *value = [jsonArray[0] objectForKey:@"value"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *errorAlert = [[UIAlertView alloc]
                                               initWithTitle:@"Forgot password" message:value delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [errorAlert show];
                });
            }
        }];
    }
    else{
        UIAlertView *errorAlert = [[UIAlertView alloc]
                                   initWithTitle:@"PlayerCV" message:@"You need to enter a valid email" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
    }
}


#pragma mark - FBLoginViewDelegate
// This method will be called when the user information has been fetched
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    
    if (!self.isViewLoaded || !self.view.window) {
        return;
    }
    
    if (self.messageCounter >0){
        return;
    }
    else
    {
        self.messageCounter++;
    
        NSString *facebookPlayerID = user.id;
        //playerName.text = user.name;
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"Loading";

       // [self doSomethingInBackgroundWithProgressCallback:^(float progress) {
       //     hud.progress = progress;
        //} completionCallback:^{
       //     [hud hide:YES];
       // }];
      
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://newfootballers.com/login_player_fb.php"]];
        [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
        [request setHTTPBody:[[NSString stringWithFormat:@"fb=%@", facebookPlayerID]dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPMethod:@"POST"];
        
        
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            
            [hud hide:YES];
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

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    // test to see if we can use the share dialog built into the Facebook application
    FBShareDialogParams *p = [[FBShareDialogParams alloc] init];
    p.link = [NSURL URLWithString:@"http://developers.facebook.com/ios"];
#ifdef DEBUG
    [FBSettings enableBetaFeatures:FBBetaFeaturesShareDialog];
#endif
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

@end
