//
//  LoginController.h
//  theImage
//
//  Created by Andrew Buttigieg on 3/5/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface LoginController : UIViewController<FBLoginViewDelegate>

@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UITextField *password;
- (IBAction)login:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewLogin;
@property (strong, nonatomic) IBOutlet UITextField *activeTextFieldLogin;

@end