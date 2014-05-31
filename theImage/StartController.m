//
//  StartController.m
//  theImage
//
//  Created by Andrew Buttigieg on 3/5/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import "AppDelegate.h"
#import "StartController.h"
#import "KeychainItemWrapper.h"
#import "JNKeychain.h"
#import "LogMeIn.h"
#import "PlayerController.h"
#import "MainVC.h"
#import <FacebookSDK/FacebookSDK.h>
#import "UIViewController+AMSlideMenu.h"

@interface StartController ()

@end

@implementation StartController

static int messageCounter;

+ (int) messageCounter{
    return messageCounter;
}

bool loggedIn = false;


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
//    self.delegate.currentView = @"Start";

    [self disableSlidePanGestureForLeftMenu];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.currentView = @"start";
    
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
    [super viewWillDisappear:animated];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CurrentViewController" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self, @"lastViewController", nil]];
}

- (void)applicationDidBecomeActive:(NSNotification *) notification
{
    [self.moviePlayer play];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"%@", self.navigationController.viewControllers);
    
    loggedIn = false;
    
    FBLoginView *loginView = [[FBLoginView alloc] init];
    loginView.readPermissions = @[@"user_birthday", @"basic_info", @"email", @"public_profile", @"user_friends", @"user_photos"];
    loginView.delegate = self;
    loginView.frame = CGRectOffset(loginView.frame, (self.view.center.x - (loginView.frame.size.width / 2)), 100);
    loginView.hidden = true;
    [self.view addSubview:loginView];
    
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
            
            [self GoToPlayer];
        }
    }
    else{
        [self.moviePlayer play];
    }
    
     //[keychain setObject:password forKey:(__bridge id)(kSecValueData)];
    
	// Do any additional setup after loading the view.
}


// This method will be called when the user information has been fetched
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    
    if (!self.isViewLoaded || !self.view.window) {
        return;
    }
    
    if (self.messageCounter >0 || loggedIn)
        return;
    else
    {
        self.messageCounter++;
        NSString *facebookPlayerID = user.id;
        //playerName.text = user.name;
        
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://newfootballers.com/login_player_fb.php"]];
        [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
        [request setHTTPBody:[[NSString stringWithFormat:@"fb=%@", facebookPlayerID]dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPMethod:@"POST"];
        
        
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            
            if (error) {
                //[self.delegate fetchingGroupsFailedWithError:error];
            } else {
                //[self.delegate receivedGroupsJSON:data];
                NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                                            options:0
                                                                              error:&error];
                dispatch_async(dispatch_get_main_queue(), ^{
                    for(NSDictionary *dictionary in jsonArray)
                    {
                        NSLog(@"Data Dictionary is : %@",dictionary);
                        NSString *returned = [jsonArray[0] objectForKey:@"value"];
                        int accepted = [[jsonArray[0] objectForKey:@"accepted"] intValue];
                        
                        if (accepted == 0){
                            loggedIn = false;
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Problem"
                                                                            message:[NSString stringWithFormat:@"%@",returned]
                                                                           delegate:self
                                                                  cancelButtonTitle:@"Ok"
                                                                  otherButtonTitles:nil];
                            [alert show];
                        }
                        else{
                            //logged in by fb
                            [self GoToPlayer];
                        }
                    }
                    [self setMessageCounter:0];
                });
            }
        }];
    }
}

-(void)GoToPlayer{
    loggedIn = true;
    [self.back removeFromSuperview];
    [self.moviePlayer stop];
    [self.moviePlayer setContentURL:nil];
    [self.moviePlayer.view removeFromSuperview];
    
    NSString * storyboardName = @"Main_iPhone";
    NSString * viewControllerID = @"Main";
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    MainVC * controller = (MainVC *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (loggedIn){
        self.navigationController.navigationBarHidden = YES;
    }
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
