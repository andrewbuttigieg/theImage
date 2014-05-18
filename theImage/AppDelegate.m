//
//  AppDelegate.m
//  theImage
//
//  Created by Andrew Buttigieg on 1/1/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import "ViewController.h"
#import "LogMeIn.h"
#import "LoginController.h"
#import "StartController.h"

@interface AppDelegate (){
    id lastViewController;
}
@end

@implementation AppDelegate
@synthesize currentView;

bool isAppResumingFromBackground = NO;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [FBLoginView class];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
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
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    
    // You can add your app-specific url handling code here if needed
    
    
    return wasHandled;
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
                                StartController * startController = (StartController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"StartController"];
                                
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
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
