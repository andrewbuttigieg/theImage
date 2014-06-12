//
//  AppDelegate.h
//  theImage
//
//  Created by Andrew Buttigieg on 1/1/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
     NSString *currentView;
     NSString *theDeviceToken;
    int messageAPNID;
    int connectionAPNID;
    bool fullScreenVideoIsPlaying;
}

@property (nonatomic) NSString * currentView;
@property (nonatomic) NSString * theDeviceToken;

@property (nonatomic) int messageAPNID;
@property (nonatomic) int connectionAPNID;
@property (nonatomic) bool fullScreenVideoIsPlaying;

@property (strong, nonatomic) UIWindow *window;

@end
