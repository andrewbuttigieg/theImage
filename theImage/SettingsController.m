 
//
//  SettingsController.m
//  theImage
//
//  Created by Andrew Buttigieg on 4/20/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import "SettingsController.h"
#import "PlayerController.h"
#import "LogMeIn.h"
#import <FacebookSDK/FacebookSDK.h>
#import "StartController.h"

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

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath {
    if (indexPath.section == 1){
        //int idx=indexPath.row;
        
        if (indexPath.row == 0){
            if ([LogMeIn logout]){
                
                if (FBSession.activeSession.isOpen)
                {
                    [FBSession.activeSession closeAndClearTokenInformation];
                }
                
                
                NSString * storyboardName = @"Main_iPhone";
                NSString * viewControllerID = @"StartController";
                
                NSLog(@"%@", self.navigationController.viewControllers);
                
                UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
                StartController * controller = (StartController *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
                
                NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
                [viewControllers replaceObjectAtIndex:0 withObject:controller];
                
                //[self.navigationController pushViewController:controller animated:YES];
                [self.navigationController setViewControllers:viewControllers animated:YES];
            }
        }
        else if (indexPath.row == 1){
            UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Are you sure that you want to delete your account?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                                    @"Yes",
                                    nil];
            popup.tag = 1;
            [popup showInView:[UIApplication sharedApplication].keyWindow];
        }
    }
}


- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (popup.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:{
                    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://newfootballers.com/delete_me.php/"]];
                    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
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
                        
                        if ([LogMeIn logout]){
                            
                            if (FBSession.activeSession.isOpen)
                            {
                                [FBSession.activeSession closeAndClearTokenInformation];
                            }
                        }
                        
                        NSString * storyboardName = @"Main_iPhone";
                        NSString * viewControllerID = @"StartController";
                        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
                        StartController * controller = (StartController *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];                        
                        [self.navigationController pushViewController:controller animated:YES];
                    }
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
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

- (IBAction)logOut:(id)sender {
}
@end
