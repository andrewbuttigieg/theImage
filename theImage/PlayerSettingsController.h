//
//  PlayerSettingsController.h
//  theImage
//
//  Created by Andrew Buttigieg on 1/12/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerSettingsController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *height;
@property (strong, nonatomic) IBOutlet UITextField *weight;
@property (strong, nonatomic) IBOutlet UITextField *position;
@property (strong, nonatomic) IBOutlet UITextField *about;

- (IBAction)save_player:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *toUpload;

- (IBAction)uploadImage:(id)sender;
- (IBAction)uploadImageMe:(id)sender;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;

@property (strong, nonatomic) IBOutlet UITextField *age;

@property (strong, nonatomic) IBOutlet UITextField *gender;

@property (strong, nonatomic) IBOutlet UITextField *email;

@property (strong, nonatomic) IBOutlet UITextField *phone;

@property (strong, nonatomic) IBOutlet UITextField *activePlayerTextField;

@property (strong, nonatomic) IBOutlet UITextField *name;

@property (strong, nonatomic) IBOutlet UITextField *surname;

@end
