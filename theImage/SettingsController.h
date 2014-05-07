//
//  SettingsController.h
//  theImage
//
//  Created by Andrew Buttigieg on 4/20/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsController : UIViewController
@property (strong, nonatomic) IBOutlet UISwitch *useLocalizationSwitch;
- (IBAction)localizationClick:(id)sender;

@end
