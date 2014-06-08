//
//  SignUpController.h
//  theImage
//
//  Created by Andrew Buttigieg on 3/4/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface SignUpController : UIViewController<UIActionSheetDelegate, FBLoginViewDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) IBOutlet UIPickerView *picker;
@property (strong, nonatomic) NSMutableArray *userTypeArray;

@property (strong, nonatomic) IBOutlet UITextField *accountType;
@property (strong, nonatomic) IBOutlet UITextField *name;
@property (strong, nonatomic) IBOutlet UITextField *lastName;
@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UITextField *activeTextField;
@property (nonatomic) int messageCounter;

- (IBAction)Done:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *backgroundview;
@end
