//
//  SignUpController.m
//  theImage
//
//  Created by Andrew Buttigieg on 3/4/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import "SignUpController.h"

@interface SignUpController ()

@end

@implementation SignUpController

CGSize keyboardSize;
bool moved = false;

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
    
//    self.activeTextField = self.password;

    
    self.name.delegate = self;
    self.lastName.delegate = self;
    self.weight.delegate = self;
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
    
    if (moved ){
    /*// Step 2: Adjust the bottom content inset of your scroll view by the keyboard height.
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(
           self.scrollView.contentInset.top,
           self.scrollView.contentInset.left, keyboardSize.height, 0.0);
    
        self.scrollView.contentInset = contentInsets;
        self.scrollView.scrollIndicatorInsets = contentInsets;
    */
    // Step 3: Scroll the target text field into view.
        CGRect aRect = self.view.frame;
        aRect.size.height -= keyboardSize.height;
    //if (!CGRectContainsPoint(aRect, self.activeTextField.frame.origin) ) {
            CGPoint scrollPoint = CGPointMake(0.0, self.activeTextField.frame.origin.y - (keyboardSize.height-35));
            [self.scrollView setContentOffset:scrollPoint animated:YES];
            //        [self.scrollView scrollRectToVisible:scrollPoint animated:YES];
   // }
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.activeTextField = nil;
    
}


- (void) keyboardWillHide:(NSNotification *)notification {
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    /*self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;*/
    
    moved = false;
}

- (void)keyboardWasShown:(NSNotification *)notification
{
    
    // Step 1: Get the size of the keyboard.
    keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
   /* int top = self.scrollView.contentInset.top;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(
                                                  self.scrollView.contentInset.top,
                                                  self.scrollView.contentInset.left, keyboardSize.height, 0.0);
    // Step 2: Adjust the bottom content inset of your scroll view by the keyboard height.
     contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
    
    contentInsets.top = top;
    
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;*/
    
    // Step 3: Scroll the target text field into view.
    CGRect aRect = self.view.frame;
    aRect.size.height -= keyboardSize.height;
    CGRect rect = [[UIApplication sharedApplication] statusBarFrame];
    CGPoint xxx = self.activeTextField.frame.origin;
    xxx.y += self.navigationController.navigationBar.frame.size.height + rect.size.height;
    
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

- (IBAction)Done:(id)sender {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://newfootballers.com/reg_player.php/"]];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [request setHTTPBody:[[NSString stringWithFormat:@"password=%@&email=%@&name=%@&lname=%@&weight=%@usertype=%@",
                           self.password.text, self.email.text, self.name.text,self.lastName.text, self.weight.text, self.accountType.text]dataUsingEncoding:NSUTF8StringEncoding]];
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
            });
        }
    }
}
@end
