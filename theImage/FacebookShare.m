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
        
        NSURL *imageURL = [NSURL URLWithString:@"http://playercv.com/fb-icon.png"];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage *image = [UIImage imageWithData:imageData];
        [FBRequestConnection startForUploadStagingResourceWithImage:image completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if(!error) {
                NSLog(@"Successfuly staged image with staged URI: %@", [result objectForKey:@"uri"]);
                
                // instantiate a Facebook Open Graph object
                NSMutableDictionary<FBOpenGraphObject> *object = [FBGraphObject openGraphObjectForPost];
                
                // specify that this Open Graph object will be posted to Facebook
                object.provisionedForPost = YES;
                
                // for og:title
                object[@"title"] = message;
                
                // for og:type, this corresponds to the Namespace you've set for your app and the object type name
                object[@"type"] = @"player-cv:player";
                
                // for og:description
                object[@"description"] = @"Revolutionary football app designed to give Players, Agents, Scouts and Coaches more chance to connect.";
                
                // for og:url, we cover how this is used in the "Deep Linking" section below
                object[@"url"] = @"https://itunes.apple.com/us/app/playercv-football-connections/id889712718";
                
                // for og:image we assign the uri of the image that we just staged
                object[@"image"] = @[@{@"url": [result objectForKey:@"uri"], @"user_generated" : @"false" }];
                
                // Post custom object
                [FBRequestConnection startForPostOpenGraphObject:object completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                    if(!error) {
                        // get the object ID for the Open Graph object that is now stored in the Object API
                        NSString *objectId = [result objectForKey:@"id"];
                        NSLog(@"object id: %@", objectId);
                        
                        // create an Open Graph action
                        id<FBOpenGraphAction> action = (id<FBOpenGraphAction>)[FBGraphObject graphObject];
                        [action setObject:objectId forKey:@"player"];
                        
                        // create action referencing user owned object
                        [FBRequestConnection startForPostWithGraphPath:@"/me/player-cv:connected_with" graphObject:action completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                            if(!error) {
                                NSLog(@"OG story posted, story id: %@", [result objectForKey:@"id"]);
                                /*[[[UIAlertView alloc] initWithTitle:@"OG story posted"
                                                            message:@"Check your Facebook profile or activity log to see the story."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK!"
                                                  otherButtonTitles:nil] show];*/
                            } else {
                                // An error occurred, we need to handle the error
                                // See: https://developers.facebook.com/docs/ios/errors
                                NSLog(@"Encountered an error posting to Open Graph: %@", error.description);
                            }
                        }];
                        
                    } else {
                        // An error occurred, we need to handle the error
                        // See: https://developers.facebook.com/docs/ios/errors
                        NSLog(@"Encountered an error posting to Open Graph: %@", error.description);
                    }
                }];
                
            } else {
                // An error occurred, we need to handle the error
                // See: https://developers.facebook.com/docs/ios/errors
                NSLog(@"Error staging an image: %@", error.description);
            }
        }];
        /*
        NSMutableDictionary<FBGraphObject> *action = [FBGraphObject graphObject];
        action[@"player"] = @"claytontonna";
        
        [FBRequestConnection startForPostWithGraphPath:@"me/player-cv:connected_with"
                                           graphObject:action
                                     completionHandler:^(FBRequestConnection *connection,
                                                         id result,
                                                         NSError *error) {*/
        /*NSMutableDictionary<FBGraphObject> *action = [FBGraphObject graphObject];
        action[@"player"] = @"http://samples.ogp.me/693315917413053";
        
        [FBRequestConnection startForPostWithGraphPath:@"me/player-cv:connected_with"
                                           graphObject:action
                                     completionHandler:^(FBRequestConnection *connection,
                                                         id result,
                                                         NSError *error) {
                                         // handle the result
                                         if (error) {
                                             // An error occurred, we need to handle the error
                                             // See: https://developers.facebook.com/docs/ios/errors
                                             NSLog(@"Error publishing story: %@", error.description);
                                         } else {
                                             {
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
        */
        /*
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"Player CV", @"name",
                                       message, @"caption",
                                       @"Revolutionary football app designed to give Players, Agents, Scouts and Coaches more chance to connect.", @"description",
                                       @"https://itunes.apple.com/us/app/playercv-football-connections/id889712718", @"link",
                                       @"http://playercv.com/fb-icon.png", @"picture",
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
                                      {
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
        */
    }
}

@end
