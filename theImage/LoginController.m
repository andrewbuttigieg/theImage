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

@interface LoginController ()

@end

@implementation LoginController


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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.email.delegate = self;
    self.password.delegate = self;
    
    FBLoginView *loginView = [[FBLoginView alloc] init];
    // Align the button in the center horizontally
    loginView.readPermissions = @[@"basic_info", @"email", @"user_likes"];
    loginView.delegate = self;
    loginView.frame = CGRectOffset(loginView.frame, (self.view.center.x - (loginView.frame.size.width / 2)), 80);
    [self.scrollViewLogin addSubview:loginView];
    
    self.scrollViewLogin.contentSize = CGSizeMake(320, 480);
    
    
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

// This method will be called when the user information has been fetched
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    
    
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
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Problem"
                                                                        message:[NSString stringWithFormat:@"%@",returned]
                                                                       delegate:self
                                                              cancelButtonTitle:@"Ok"
                                                              otherButtonTitles:nil];
                        [alert show];
                    }
                    else{    
                        //logged in by fb
                        [self GoToPlayer];
                    }
                }
            });
        }
    }];
    
}

// Handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    
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
    
    if (movedHere ){
        // Step 3: Scroll the target text field into view.
        CGRect aRect = self.view.frame;
        aRect.size.height -= keyboardSize.height;
        //if (!CGRectContainsPoint(aRect, self.activeTextField.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, self.activeTextFieldLogin.frame.origin.y - (keyboardSize.height-35));
        [self.scrollViewLogin setContentOffset:scrollPoint animated:YES];
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.activeTextFieldLogin = nil;
    
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
        CGPoint scrollPoint = CGPointMake(0.0, self.activeTextFieldLogin.frame.origin.y - (keyboardSize.height-55));
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
        [self GoToPlayer];
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
                                   initWithTitle:@"Error" message:@"You need to enter a valid email" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
    }
}
@end
