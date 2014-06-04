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
}

@property (nonatomic) NSString * currentView;
@property (nonatomic) NSString * theDeviceToken;
@property (nonatomic) int messageAPNID;
@property (strong, nonatomic) UIWindow *window;

@end
