//
//  PlayerSettingsController.h
//  theImage
//
//  Created by Andrew Buttigieg on 1/12/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerSettingsController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) IBOutlet UIPickerView *picker;

@property (strong, nonatomic) NSArray *genderArray;
@property (strong, nonatomic) IBOutlet UITextField *height;
@property (strong, nonatomic) IBOutlet UITextField *weight;
@property (strong, nonatomic) IBOutlet UITextField *position;
@property (strong, nonatomic) IBOutlet UITextField *about;

- (IBAction)save_player:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *toUpload;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;

@property (strong, nonatomic) IBOutlet UITextField *age;

- (IBAction)genderClick:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *gender;

@property (strong, nonatomic) IBOutlet UITextField *email;

@property (strong, nonatomic) IBOutlet UITextField *phone;

@property (strong, nonatomic) IBOutlet UITextField *activePlayerTextField;

@property (strong, nonatomic) IBOutlet UITextField *name;

@property (strong, nonatomic) IBOutlet UITextField *surname;

- (IBAction)findImage:(id)sender;

- (IBAction)lookingForPlayer:(id)sender;
@property (strong, nonatomic) IBOutlet UISwitch *lookingForPlayerButton;

@property (strong, nonatomic) IBOutlet UITextField *lfpPosition;
@property (strong, nonatomic) IBOutlet UIImageView *lfpPositionImage;

@property (strong, nonatomic) IBOutlet UITextField *lfpCountry;
@property (strong, nonatomic) IBOutlet UIImageView *lfpCountryImage;

@property (strong, nonatomic) IBOutlet UIView *privateInformationView;




@end
