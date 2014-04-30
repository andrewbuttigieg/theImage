 
//
//  SettingsController.m
//  theImage
//
//  Created by Andrew Buttigieg on 4/20/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import "SettingsController.h"
#import "PlayerController.h"

@interface SettingsController ()

@end

@implementation SettingsController

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
	// Do any additional setup after loading the view.
    self.useLocalizationSwitch.on = PlayerController.useLocalisation;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
