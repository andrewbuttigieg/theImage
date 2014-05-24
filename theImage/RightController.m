//
//  LeftController.m
//  theImage
//
//  Created by Andrew Buttigieg on 3/18/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import "RightController.h"

@implementation RightController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 && ![UIApplication sharedApplication].isStatusBarHidden)
    {
        self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    }
}

@end