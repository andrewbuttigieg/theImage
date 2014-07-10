//
//  FacebookShare.m
//  Player CV
//
//  Created by Andrew Buttigieg on 7/10/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import "FacebookShare.h"
#import <FacebookSDK/FacebookSDK.h>

@implementation FacebookShare

//------------------------------------

// A function for parsing URL parameters returned by the Feed Dialog.
+ (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

//------------------Sharing a link using the share dialog------------------
+ (void)shareLinkWithShareDialog:(NSString *)message
{
    
    // Check if the Facebook app is installed and we can present the share dialog
    FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
    params.link = [NSURL URLWithString:@"https://developers.facebook.com/docs/ios/share/"];
    
    // If the Facebook app is installed and we can present the share dialog
    if ([FBDialogs canPresentShareDialogWithParams:params]) {
        // Present share dialog
        [FBDialogs presentShareDialogWithLink:params.link
                                      handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                          if(error) {
                                              // An error occurred, we need to handle the error
                                              // See: https://developers.facebook.com/docs/ios/errors
                                              NSLog(@"Error publishing story: %@", error.description);
                                          } else {
                                              // Success
                                              NSLog(@"result %@", results);
                                          }
                                      }];
    } else {
        
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       /*@"name", @"name",
                                        @"http://www.google.com", @"link",
                                        @"caption!", @"caption",
                                        @"description", @"description",*/
                                       
                                       @"Player CV", @"name",
                                       @"PLAYERS. AGENTS. SCOUTS. COACHES. EVERYONE.", @"caption",
                                       @"Revolutionary football app designed to give Players, Agents, Scouts and Coaches more chance to connect.", @"description",
                                       @"https://itunes.apple.com/us/app/playercv-football-connections/id889712718", @"link",
                                       @"http://playercv.com/fb-icon.png", @"picture",
                                       message
                                       /*@"Andrew Buttigieg is now connected with Football Agent Clayton Tonna on PlayerCV!"*/, @"message",
                                       nil];
        
        // Publish.
        // This is the most important method that you call. It does the actual job, the message posting.
        //[facebook requestWithGraphPath:@"me/feed" andParams:params andHttpMethod:@"POST" andDelegate:self];
        
        
        [FBRequestConnection startWithGraphPath:@"/me/feed"
                                     parameters:params
                                     HTTPMethod:@"POST"
                              completionHandler:^(
                                                  FBRequestConnection *connection,
                                                  id result,
                                                  NSError *error
                                                  ) {
                                  if (error) {
                                      // An error occurred, we need to handle the error
                                      // See: https://developers.facebook.com/docs/ios/errors
                                      NSLog(@"Error publishing story: %@", error.description);
                                  } else {
                                      /*if (connection == FBWebDialogResultDialogNotCompleted) {
                                       // User cancelled.
                                       NSLog(@"User cancelled.");
                                       } else */{
                                           // Handle the publish feed callback
                                           NSDictionary *urlParams = [self parseURLParams:[result query]];
                                           
                                           if (![urlParams valueForKey:@"post_id"]) {
                                               // User cancelled.
                                               NSLog(@"User cancelled.");
                                               
                                           } else {
                                               // User clicked the Share button
                                               NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                               NSLog(@"result %@", result);
                                           }
                                       }
                                  }
                              }];
        
        // Put together the dialog parameters
        /* NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
         @"Player CV", @"name",
         @"PLAYERS. AGENTS. SCOUTS. COACHES. EVERYONE.", @"caption",
         @"Revolutionary football app designed to give Players, Agents, Scouts and Coaches more chance to connect.", @"description",
         @"http://playercv.com/", @"link",
         @"http://playercv.com/fb-icon.png", @"picture",
         nil];
         
         // Show the feed dialog
         [FBWebDialogs presentFeedDialogModallyWithSession:nil
         parameters:params
         handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
         if (error) {
         // An error occurred, we need to handle the error
         // See: https://developers.facebook.com/docs/ios/errors
         NSLog(@"Error publishing story: %@", error.description);
         } else {
         if (result == FBWebDialogResultDialogNotCompleted) {
         // User cancelled.
         NSLog(@"User cancelled.");
         } else {
         // Handle the publish feed callback
         NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
         
         if (![urlParams valueForKey:@"post_id"]) {
         // User cancelled.
         NSLog(@"User cancelled.");
         
         } else {
         // User clicked the Share button
         NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
         NSLog(@"result %@", result);
         }
         }
         }
         }];
         */
    }
}

@end
