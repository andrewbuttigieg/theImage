 
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

- (IBAction)localizationClick:(id)sender {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://newfootballers.com/update_user_localisation.php/"]];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [request setHTTPBody:[[NSString stringWithFormat:@"allowLocalisation=%@",
                           self.useLocalizationSwitch.on ? @"1": @"0"]dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    NSError *error = nil; NSURLResponse *response = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error) {
        NSLog(@"Error:%@", error.localizedDescription);
    }
    else {
        //success
        NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:0
                                                                      error:&error];
        
        NSLog(@"Data Dictionary is : %@", jsonArray);
    }
    PlayerController.useLocalisation = self.useLocalizationSwitch.on;
}
@end
