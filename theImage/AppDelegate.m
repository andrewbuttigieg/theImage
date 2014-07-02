//
//  AppDelegate.m
//  theImage
//
//  Created by Andrew Buttigieg on 1/1/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import "LogMeIn.h"
#import "LoginController.h"
#import "StartController.h"
#import "MessageViewController.h"
#import "MainVC.h"
#import "PlayerController.h"

@interface AppDelegate (){
    id lastViewController;
}
@end

@implementation AppDelegate
@synthesize currentView;
@synthesize theDeviceToken;
@synthesize messageAPNID;
@synthesize connectionAPNID;
@synthesize fullScreenVideoIsPlaying;

bool isAppResumingFromBackground = NO;

//----------

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    
    NSLog(@"Registering for push notifications...");
    [[UIApplication sharedApplication]
     registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeAlert |
      UIRemoteNotificationTypeBadge |
      UIRemoteNotificationTypeSound)];
    
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString *str = [NSString
                     stringWithFormat:@"Device Token=%@",deviceToken];
    
    theDeviceToken = str;
    
    /*NSLog(@"%@", str);
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"PlayerCV - didRegisterForRemoteNotificationsWithDeviceToken"
                                                   message: str
                                                  delegate: self
                                         cancelButtonTitle: @"OK"
                                         otherButtonTitles:nil];
    
    
    [alert show];*/
    
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    
    if (err.code != 3010){
        NSString *str = [NSString stringWithFormat: @"Error: %@", err];
        NSLog(@"%@", str);
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"PlayerCV - didFailToRegisterForRemoteNotificationsWithError"
                                                       message: str
                                                      delegate: self
                                             cancelButtonTitle: @"OK"
                                             otherButtonTitles:nil];
        
        
        [alert show];
    }
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    if (self.fullScreenVideoIsPlaying) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

- (void)resetAppToFirstController
{
    self.window.rootViewController = [[StartController alloc] initWithNibName:nil bundle:nil];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateInactive || state == UIApplicationStateBackground) {
        
        //NSString *alertValue = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
        int fromValue = -1;
        int connectReq = -1;
        
        if ([userInfo valueForKey:@"aps"] != [NSNull null] &&
            [userInfo valueForKey:@"aps"] != nil &&
            [[userInfo valueForKey:@"aps"] valueForKey:@"from"] != [NSNull null] &&
            [[userInfo valueForKey:@"aps"] valueForKey:@"from"] != nil){
            fromValue = [[[userInfo valueForKey:@"aps"] valueForKey:@"from"] intValue];
        }
        
        if ([userInfo valueForKey:@"aps"] != [NSNull null] &&
            [userInfo valueForKey:@"aps"] != nil &&
            [[userInfo valueForKey:@"aps"] valueForKey:@"req"] != [NSNull null] &&
            [[userInfo valueForKey:@"aps"] valueForKey:@"req"] != nil){
            connectReq = [[[userInfo valueForKey:@"aps"] valueForKey:@"req"] intValue];
        }
        
        /*
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"PlayerCV - from value"
                                                       message: [NSString stringWithFormat:@"%d", fromValue]
                                                      delegate: self
                                             cancelButtonTitle: @"OK"
                                             otherButtonTitles:nil];
        [alert show];*/
       /*
        alert = [[UIAlertView alloc]initWithTitle: @"PlayerCV - didReceiveRemoteNotification"
                                          message: [NSString stringWithFormat:@"%d", fromValue]
                                         delegate: self
                                cancelButtonTitle: @"OK"
                                otherButtonTitles:nil];
        [alert show];*/
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://newfootballers.com/is_logged_in.php/"]];
        [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
        [request setHTTPMethod:@"POST"];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            
            if (error) {
                
            } else {
                NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                                            options:0
                                                                              error:&error];
                for(NSDictionary *dictionary in jsonArray)
                {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if ([[dictionary objectForKey:@"accepted"] intValue] == 1){
                            //logged in
                            UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController.navigationController;
                            if (![[navigationController.viewControllers objectAtIndex: navigationController.viewControllers.count - 1] isKindOfClass:[MessageViewController class]]){
                                
                                messageAPNID = -1;
                                connectionAPNID = -1;
                                //from
                                if (fromValue > 0){
                                    NSString * storyboardName = @"Main_iPhone";
                                    NSString * viewControllerID = @"Main";
                                    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
                                    MainVC * controller = (MainVC *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
                                    messageAPNID = fromValue;
                                    self.window.rootViewController = controller;
                                }
                                
                                //connection
                                else if (connectReq > 0){
                                    NSString * storyboardName = @"Main_iPhone";
                                    NSString * viewControllerID = @"Main";
                                    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
                                    MainVC * controller = (MainVC *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
                                    connectionAPNID = connectReq;
                                    self.window.rootViewController = controller;
                                }
                            }
                        }
                    }); //dispatch_async
                }
            }
        }]; //req
    }
}

//----------

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [FBLoginView class];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    NSLog(@"Registering for push notifications...");
    [[UIApplication sharedApplication]
     registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeAlert |
      UIRemoteNotificationTypeBadge |
      UIRemoteNotificationTypeSound)];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    if (isAppResumingFromBackground) {
        
        // Show Alert Here
    }
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
  //  BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    
    // You can add your app-specific url handling code here if needed
    
    
//    return wasHandled;
    
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                    fallbackHandler:^(FBAppCall *call) {
                        NSLog(@"In fallback handler");
                    }];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    isAppResumingFromBackground = YES;
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
   /* UIViewController *vc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    
    NSLog(@"%@", vc.title);
    */
    //if (![vc.title isEqualToString:@"start"] && ![vc.title isEqualToString:@"Login"] && ![vc.title isEqualToString:@"Signup"]){
    if (![currentView isEqualToString:@"start"]){
    
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://newfootballers.com/is_logged_in.php/"]];
        [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
        [request setHTTPMethod:@"POST"];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            
            if (error) {
                
            } else {
                NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                                            options:0
                                                                              error:&error];
                for(NSDictionary *dictionary in jsonArray)
                {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if ([[dictionary objectForKey:@"accepted"] intValue] == 1){
                            //logged in
                        }
                        else{
                            //logged out
                            if ([LogMeIn logout]){
                                
                                if (FBSession.activeSession.isOpen)
                                {
                                    [FBSession.activeSession closeAndClearTokenInformation];
                                }
                                UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle: nil];
                                UINavigationController * startController = (UINavigationController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"Beginning"];
                                
                                //set the root controller to it
                                self.window.rootViewController = startController;
                            }
                        }
                    });
                }
            }
        }];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    // FBSample logic
    // Call the 'activateApp' method to log an app event for use in analytics and advertising reporting.
    [FBAppEvents activateApp];
    
    // FBSample logic
    // We need to properly handle activation of the application with regards to SSO
    //  (e.g., returning from iOS 6.0 authorization dialog or from fast app switching).
    [FBAppCall handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [FBSession.activeSession close];
}

@end
