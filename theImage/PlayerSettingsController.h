//
//  PlayerSettingsController.h
//  theImage
//
//  Created by Andrew Buttigieg on 1/12/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PlayerSettingsController;

@protocol PlayerImageDelegate <NSObject>
/*
- (void)playerDetailsViewControllerDidSave:
(PlayerSettingsController *)controller;*/

- (void)addItemViewController:(id)controller uploadedImage:(UIImage *)item :(int)imagePos;

- (void)addItemViewController:(id)controller didSave :(NSString *)name :(NSString *)lname
                             :(NSString *)about :(NSString *)age :(NSString *)weight :(NSString *)height
                             :(NSString *)position :(BOOL)lookingForPlayer
                             :(NSString *)lfpCountry :(NSString *)lfpPosition
                             :(BOOL)lookingForPartner :(NSString *)lfpartCountry;
@end

@interface PlayerSettingsController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource,
    UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (strong, nonatomic) IBOutlet UIView *playerOnlyView;
@property (strong, nonatomic) IBOutlet UIView *aboutView;

@property (strong, nonatomic) IBOutlet UIPickerView *picker;
@property (strong, nonatomic) IBOutlet UIPickerView *countryPicker;
@property (strong, nonatomic) IBOutlet UIPickerView *countryPicker2;
@property (strong, nonatomic) IBOutlet UIPickerView *positionPicker;
@property (strong, nonatomic) IBOutlet UIPickerView *positionPicker2;

@property (strong, nonatomic) NSMutableArray *genderArray;
@property (strong, nonatomic) NSMutableArray *countryArray;
@property (strong, nonatomic) NSMutableArray *positionArray;

@property (strong, nonatomic) IBOutlet UITextField *height;
@property (strong, nonatomic) IBOutlet UITextField *weight;
@property (strong, nonatomic) IBOutlet UITextField *position;

@property (strong, nonatomic) IBOutlet UITextView *about;
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

@property (strong, nonatomic) IBOutlet UIButton *changePwd;

- (IBAction)image2:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *image2Outlet;
- (IBAction)image3:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *image3Outlet;
- (IBAction)image4:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *image4Outlet;
- (IBAction)image5:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *image5Outlet;

@property (nonatomic, weak) id <PlayerImageDelegate> delegate;

@end