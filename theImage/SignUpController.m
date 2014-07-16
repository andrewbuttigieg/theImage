//
//  SignUpController.m
//  theImage
//
//  Created by Andrew Buttigieg on 3/4/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import "SignUpController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "JNKeychain.h"
#import "LogMeIn.h"
#import "MainVC.h"
#import "UIViewController+AMSlideMenu.h"
#import "AppDelegate.h"

@interface SignUpController () <FBLoginViewDelegate>

@end

@implementation SignUpController

static int messageCounter;

+ (int) messageCounter{
    return messageCounter;
}

CGSize keyboardSize;
bool moved = false;
static id<FBGraphUser> facebookUser;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)applicationDidBecomeActive:(NSNotification *) notification
{
    [self.moviePlayer play];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Sign Up";
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"signup-background.jpg"]]];
    
    self.userTypeArray =  [[NSMutableArray alloc]initWithObjects:@"", @"Player",@"Scout",@"Agent", @"Coach" , nil];
    self.picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 100, 150)];
    [self.picker setDataSource: self];
    [self.picker setDelegate: self];
    self.picker.showsSelectionIndicator = YES;
    self.accountType.inputView = self.picker;
    
    NSString*thePath=[[NSBundle mainBundle] pathForResource:@"intro" ofType:@"mp4"];
    NSURL*theurl=[NSURL fileURLWithPath:thePath];
    
    self.moviePlayer=[[MPMoviePlayerController alloc] initWithContentURL:theurl];
    self.moviePlayer.controlStyle = MPMovieControlStyleNone;
    [self.moviePlayer.view setFrame:CGRectMake(0, 0, 320, (1138 / 2))];
    [self.moviePlayer prepareToPlay];
    [self.moviePlayer setRepeatMode:YES];
    [self.moviePlayer setShouldAutoplay:NO];
    [self.back addSubview:self.moviePlayer.view];
    
    
    FBLoginView *loginView = [[FBLoginView alloc] init];
    // Align the button in the center horizontally
    loginView.readPermissions = @[@"email", @"public_profile", @"user_friends", @"publish_actions"];
    
    //loginView.readPermissions = @[@"user_birthday", @"basic_info", @"email", @"public_profile", @"user_friends", @"user_photos"];
    //loginView.readPermissions = @[@"email", @"public_profile", @"user_friends"];
    loginView.delegate = self;
    loginView.frame = CGRectOffset(loginView.frame, (self.view.center.x - (loginView.frame.size.width / 2)), 20);
    
    for (id obj in loginView.subviews)
    {
        if ([obj isKindOfClass:[UILabel class]])
        {
            UILabel * loginLabel =  obj;
            loginLabel.text = @"Sign Up with Facebook";
        }
    }
    
    [self.view addSubview:loginView];
    
   /*
    FBLoginView *loginview = [[FBLoginView alloc] init];
    
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
    [self.view addSubview:loginview];*/
    
    
    self.name.delegate = self;
    self.lastName.delegate = self;
    self.email.delegate = self;
    self.password.delegate = self;
    
    
    self.scrollView.contentSize = CGSizeMake(320, 480);
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
	// Do any additional setup after loading the view.
}

- (void)signupFacebook:(int)userType{
    NSLog(@"%@", facebookUser);
    NSLog(@"%@", facebookUser[@"birthday"]);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://newfootballers.com/reg_player.php/"]];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    
    //userType
    
    [request setHTTPBody:
     [[NSString stringWithFormat:@"password=%@&email=%@&name=%@&lname=%@&usertype=%d&facebookid=%@&gender=%@&birthday=%@&photoURL=%@&username=%@",
       @"", facebookUser[@"email"], facebookUser.first_name, facebookUser.last_name, userType, facebookUser.id, facebookUser[@"gender"], facebookUser[@"birthday"], @"photo", facebookUser[@"username"]]dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    NSError *error = nil; NSURLResponse *response = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error) {
        NSLog(@"Error:%@", error.localizedDescription);
    }
    else {
        //success
        NSLog(@"%@", data);
        
        NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:0
                                                                      error:&error];
        NSLog(@"%@", jsonArray);
        for(NSDictionary *dictionary in jsonArray)
        {
            //NSLog(@"Data Dictionary is : %@",jsonArray);
            NSString *returned = [jsonArray[0] objectForKey:@"value"];
            int accepted = [[jsonArray[0] objectForKey:@"accepted"] intValue];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (accepted == 0){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"PlayerCV"
                                                                    message:[NSString stringWithFormat:@"%@",returned]
                                                                   delegate:self
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                    [alert show];
                }
                else{
                    
                    
                    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://newfootballers.com/login_player_fb.php"]];
                    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
                    [request setHTTPBody:[[NSString stringWithFormat:@"fb=%@", facebookUser.id]dataUsingEncoding:NSUTF8StringEncoding]];
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
                            });
                        }
                    }];
                }
            });
        }
    }
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (popup.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                    //player
                    [self signupFacebook:1];
                    break;
                case 1:
                    //scout
                    [self signupFacebook:2];
                    break;
                case 2:
                    //agent
                    [self signupFacebook:3];
                    break;
                case 3:
                    //coach
                    [self signupFacebook:4];
                    break;
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}


- (void)viewDidUnload{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)dismissKeyboard:(id)sender
{
    [self.activeTextField resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeTextField = textField;
    
    [self.moviePlayer pause];
    
    if (moved ){
        CGRect aRect = self.view.frame;
        aRect.size.height -= keyboardSize.height;
        CGPoint scrollPoint = CGPointMake(0.0, self.activeTextField.frame.origin.y - (keyboardSize.height-35));
        [self.scrollView setContentOffset:scrollPoint animated:YES];
    }
}

- (BOOL) textField: (UITextField *)theTextField shouldChangeCharactersInRange:(NSRange)range replacementString: (NSString *)string {
    //return yes or no after comparing the characters
    
    // allow backspace
    if (!string.length)
    {
        return YES;
    }
    
    // allow digit 0 to 9
    /*if (
     [self.activeTextField isEqual:self.weight] &&
     ([string intValue] || [string isEqualToString:@"0"] || [string isEqualToString:@"."] || [string isEqualToString:@","])
     )
     {
     return YES;
     }
     else if (
     [self.activeTextField isEqual:self.weight]){
     return NO;
     }*/
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.activeTextField = nil;
    
}

- (void) keyboardWillHide:(NSNotification *)notification {
    moved = false;
}

- (void)keyboardWasShown:(NSNotification *)notification
{
    keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGRect aRect = self.view.frame;
    aRect.size.height -= keyboardSize.height;
    CGRect rect = [[UIApplication sharedApplication] statusBarFrame];
    CGPoint xxx = self.activeTextField.frame.origin;
    xxx.y += self.navigationController.navigationBar.frame.size.height + rect.size.height + self.activeTextField.frame.size.height;
    
    if (!CGRectContainsPoint(aRect, xxx) ) {
        CGPoint scrollPoint = CGPointMake(0.0, self.activeTextField.frame.origin.y - (keyboardSize.height-35));
        [self.scrollView setContentOffset:scrollPoint animated:YES];
    }
    moved = true;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)GoToPlayer{
    NSString * storyboardName = @"Main_iPhone";
    NSString * viewControllerID = @"Main";
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    MainVC * controller = (MainVC *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)Done:(id)sender {
    
    NSLog(@"%@", self.accountType.text);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://newfootballers.com/reg_player.php/"]];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [request setHTTPBody:[[NSString stringWithFormat:@"password=%@&email=%@&name=%@&lname=%@&usertype=%@",
                           self.password.text, self.email.text, self.name.text,self.lastName.text, self.accountType.text]dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    NSError *error = nil; NSURLResponse *response = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error) {
        NSLog(@"Error:%@", error.localizedDescription);
    }
    else {
        //success
        NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:0
                                                                      error:&error];
        for(NSDictionary *dictionary in jsonArray)
        {
            //NSLog(@"Data Dictionary is : %@",jsonArray);
            NSString *returned = [jsonArray[0] objectForKey:@"value"];
            int accepted = [[jsonArray[0] objectForKey:@"accepted"] intValue];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (accepted == 0){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"PlayerCV"
                                                                    message:[NSString stringWithFormat:@"%@",returned]
                                                                   delegate:self
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                    [alert show];
                }
                else{
                    NSString *login = self.email.text;
                    NSString *password = self.password.text;
                    
                    if ([LogMeIn login:login :password]){
                        [self GoToPlayer];
                    }
                }
            });
        }
    }
}



#pragma mark - FBLoginViewDelegate
// This method will be called when the user information has been fetched
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    if (!self.isViewLoaded || !self.view.window) {
        return;
    }
    
    if (self.messageCounter >0)
        return;
    else
    {
        self.messageCounter++;
        facebookUser = user;
        
        UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"What type of user are you? (by clicking you are agreeing to our Terms and Conditions and our Privacy Policy): " delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                                @"Player",
                                @"Scout",
                                @"Agent",
                                @"Coach",
                                nil];
        popup.tag = 1;
        [popup showInView:[UIApplication sharedApplication].keyWindow];
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

#pragma mark -
#pragma mark PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return self.userTypeArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return [self.userTypeArray objectAtIndex:row];
}

#pragma mark -
#pragma mark PickerView Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    NSString *type = self.userTypeArray[row];
    self.accountType.text = type;
}
@end
