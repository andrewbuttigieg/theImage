//
//  LoginController.h
//  theImage
//
//  Created by Andrew Buttigieg on 3/5/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <MediaPlayer/MediaPlayer.h>

@interface LoginController : UIViewController<FBLoginViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UITextField *password;
- (IBAction)login:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewLogin;
@property (strong, nonatomic) IBOutlet UITextField *activeTextFieldLogin;
- (IBAction)forgotPwd:(id)sender;
- (BOOL)validateEmail:(NSString *)emailStr;

@property (nonatomic) int messageCounter;

@property (strong, nonatomic) IBOutlet MPMoviePlayerController *moviePlayer;
@property (strong, nonatomic) IBOutlet UIImageView *back;

@end
