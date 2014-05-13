//
//  SettingsController.h
//  theImage
//
//  Created by Andrew Buttigieg on 4/20/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsController : UITableViewController<UIActionSheetDelegate>
@property (strong, nonatomic) IBOutlet UISwitch *useLocalizationSwitch;
- (IBAction)localizationClick:(id)sender;

- (IBAction)logOut:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *deleteUser;

@end
