//
//  MainVC.h
//  theImage
//
//  Created by Andrew Buttigieg on 3/18/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AMSlideMenuMainViewController.h"

@class MainVC;

@protocol MainVCDelegate <NSObject>

- (void)MainVCController:(id)controller countUpdate:(int)chatCount :(int)requestCount;

@end

@interface MainVC : AMSlideMenuMainViewController<CLLocationManagerDelegate, AMSlideMenuDelegate>
    @property (nonatomic, weak) id <MainVCDelegate> delegate;
@end
