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
#import "PlayerController.h"
#import "MainVC.h"

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

- (void)applicationDidBecomeActive:(NSNotification *) notification
{
    [self.moviePlayer play];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    NSString*thePath=[[NSBundle mainBundle] pathForResource:@"intro" ofType:@"mp4"];
    NSURL*theurl=[NSURL fileURLWithPath:thePath];
    
    self.moviePlayer=[[MPMoviePlayerController alloc] initWithContentURL:theurl];
    self.moviePlayer.controlStyle = MPMovieControlStyleNone;
    [self.moviePlayer.view setFrame:CGRectMake(0, 0, 320, (1138 / 2))];
    [self.moviePlayer prepareToPlay];
    [self.moviePlayer setRepeatMode:YES];
    [self.moviePlayer setShouldAutoplay:NO];
    [self.back addSubview:self.moviePlayer.view];
    
    NSString *keyLogin = @"login";
    NSString *keyPwd = @"pwd";
    NSString *login = [JNKeychain loadValueForKey:keyLogin];
    NSString *pwd = [JNKeychain loadValueForKey:keyPwd];
    
    if (login != nil && pwd != nil){
        if ([LogMeIn login:login :pwd]){
            /*
            NSString * storyboardName = @"Main_iPhone";
            NSString * viewControllerID = @"PlayerController";
            UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
            PlayerController * controller = (PlayerController *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
            */
            NSString * storyboardName = @"Main_iPhone";
            NSString * viewControllerID = @"Main";
            UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
            MainVC * controller = (MainVC *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
            
            //[self.navigationController pushViewController:controller animated:YES];
 
            [self.back removeFromSuperview];
            [self.moviePlayer stop];
            [self.moviePlayer setContentURL:nil];
            [self.moviePlayer.view removeFromSuperview];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
    else{
        [self.moviePlayer play];
    }
    
     //[keychain setObject:password forKey:(__bridge id)(kSecValueData)];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}


@end
