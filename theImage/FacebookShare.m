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
                                [[[UIAlertView alloc] initWithTitle:@"OG story posted"
                                                            message:@"Check your Facebook profile or activity log to see the story."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK!"
                                                  otherButtonTitles:nil] show];
                            } else {
                                // An error occurred, we need to handle the error
                                // See: https://developers.facebook.com/docs/ios/errors
                                NSLog(@"Encountered an error posting to Open Graph: %@", error.description);
                                [[[UIAlertView alloc] initWithTitle:@"error"
                                                            message:error.description
                                                           delegate:self
                                                  cancelButtonTitle:@"OK!"
                                                  otherButtonTitles:nil] show];

                            }
                        }];
                        
                    } else {
                        // An error occurred, we need to handle the error
                        // See: https://developers.facebook.com/docs/ios/errors
                        NSLog(@"Encountered an error posting to Open Graph: %@", error.description);
                        [[[UIAlertView alloc] initWithTitle:@"error"
                                                    message:error.description
                                                   delegate:self
                                          cancelButtonTitle:@"OK!"
                                          otherButtonTitles:nil] show];
                    }
                }];
                
            } else {
                // An error occurred, we need to handle the error
                // See: https://developers.facebook.com/docs/ios/errors
                NSLog(@"Error staging an image: %@", error.description);
                [[[UIAlertView alloc] initWithTitle:@"error"
                                            message:error.description
                                           delegate:self
                                  cancelButtonTitle:@"OK!"
                                  otherButtonTitles:nil] show];
            }
        }];
}

@end
