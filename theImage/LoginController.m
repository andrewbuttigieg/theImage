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
#import "ViewController.h"
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
    
	// Do any additional setup after loading the view.
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


- (IBAction)login:(id)sender {
    
    NSString *login = self.email.text;
    NSString *password = self.password.text;
    
    
    if ([LogMeIn login:login :password]){
        NSString * storyboardName = @"Main_iPhone";
        NSString * viewControllerID = @"Main";
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
        ViewController * controller = (ViewController *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
    
        [self.navigationController pushViewController:controller animated:YES];
    }
    /*
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://newfootballers.com/login_player.php/"]];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [request setHTTPBody:[[NSString stringWithFormat:@"password=%@&email=%@",
                           password, login]dataUsingEncoding:NSUTF8StringEncoding]];
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
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Problem"
                                                                    message:[NSString stringWithFormat:@"%@",returned]
                                                                   delegate:self
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                    [alert show];
                }
                else{
                    //keep the crediental for next time....
                    NSString *keyLogin = @"login";
                    [JNKeychain saveValue:login forKey:keyLogin];
                    
                    NSString *keyPwd = @"pwd";
                    [JNKeychain saveValue:password forKey:keyPwd];
                    
                    NSString * storyboardName = @"Main_iPhone";
                    NSString * viewControllerID = @"Main";
                    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
                    ViewController * controller = (ViewController *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
                    
                    [self.navigationController pushViewController:controller animated:YES];
                }
            });
        }
    }
*/
    
}
@end
