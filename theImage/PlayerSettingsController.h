//
//  PlayerSettingsController.h
//  theImage
//
//  Created by Andrew Buttigieg on 1/12/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerSettingsController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource,
    UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIPickerView *picker;
@property (strong, nonatomic) IBOutlet UIPickerView *countryPicker;
@property (strong, nonatomic) IBOutlet UIPickerView *countryPicker2;

@property (strong, nonatomic) NSMutableArray *genderArray;
@property (strong, nonatomic) NSMutableArray *countryArray;

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
@property (strong, nonatomic) IBOutlet UITextField *lfpartCountry;

@property (strong, nonatomic) IBOutlet UIView *privateInformationView;

@property (strong, nonatomic) IBOutlet UIView *lookingForPlayer;

@property (strong, nonatomic) IBOutlet UISwitch *lookingForPartnerButton;
- (IBAction)lookingForPartner:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *lookingForPartnerView;
@property (strong, nonatomic) IBOutlet UIView *lookingForPartnerSwitch;

@property (strong, nonatomic) IBOutlet UIView *lookingForPlayerSwitch;

@property (strong, nonatomic) IBOutlet UILabel *marketLabel;



@end
