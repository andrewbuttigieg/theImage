//
//  MessageViewController.h
//  theImage
//
//  Created by Andrew Buttigieg on 2/25/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PHFComposeBarView.h"

@interface MessageViewController : UIViewController<PHFComposeBarViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *containerMain;


+ (float)top;

@end
