//
//  StartController.m
//  theImage
//
//  Created by Andrew Buttigieg on 3/5/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import "StartController.h"
#import "KeychainItemWrapper.h"
#import "JNKeychain.h"
#import "LogMeIn.h"
#import "ViewController.h"

@interface StartController ()

@end

@implementation StartController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.moviePlayer play];
    [super viewWillAppear:animated];
    //self.navigationController.toolbarHidden = YES;
    [self.navigationController setNavigationBarHidden:YES];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self.moviePlayer pause];
    [super viewWillDisappear:animated];
    //self.navigationController.toolbarHidden = NO;
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    //[self.navigationController setNavigationBarHidden:YES];
    
    //NSString*thePath=[[NSBundle mainBundle] pathForResource:@"intro" ofType:@"mp4"];
    /*NSURL *thePath = [[NSBundle mainBundle] URLForResource:@"intro" withExtension:@".mp4"];
    NSURL*theurl=[NSURL fileURLWithPath:thePath];
    */
    
    NSString*thePath=[[NSBundle mainBundle] pathForResource:@"intro" ofType:@"mp4"];
    NSURL*theurl=[NSURL fileURLWithPath:thePath];
    
    /*KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"TestUDID" accessGroup:nil];
    
    NSString *login = [keychain objectForKey:(__bridge id)(kSecAttrAccount)];
    NSString *pwd = [keychain objectForKey:(__bridge id)(kSecClassGenericPassword)];*/
    
    self.moviePlayer=[[MPMoviePlayerController alloc] initWithContentURL:theurl];
    [self.moviePlayer.view setFrame:CGRectMake(0, 0, 320, (1138 / 2))];
    [self.moviePlayer prepareToPlay];
    [self.moviePlayer setRepeatMode:YES];
    [self.moviePlayer setShouldAutoplay:YES]; // And other options you can look through the documentation.
    [self.back addSubview:self.moviePlayer.view];
    
    NSString *keyLogin = @"login";
    NSString *keyPwd = @"pwd";
    NSString *login = [JNKeychain loadValueForKey:keyLogin];
    NSString *pwd = [JNKeychain loadValueForKey:keyPwd];
    
    if (login != nil && pwd != nil){
        if ([LogMeIn login:login :pwd]){
            NSString * storyboardName = @"Main_iPhone";
            NSString * viewControllerID = @"Main";
            UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
            ViewController * controller = (ViewController *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
            [self.moviePlayer stop];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
    
     //[keychain setObject:password forKey:(__bridge id)(kSecValueData)];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
