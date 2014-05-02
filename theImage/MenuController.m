//
//  MenuController.m
//  theImage
//
//  Created by Andrew Buttigieg on 3/18/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import "MenuController.h"

@interface MenuController ()

@property (strong, nonatomic) UITableView *myTableView;


@end

@implementation MenuController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorColor = [UIColor clearColor];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 && ![UIApplication sharedApplication].isStatusBarHidden)
    {
        self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    }
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5f];
    [self setFixedStatusBar];
}

- (void)setFixedStatusBar
{
    self.myTableView = self.tableView;
    
    self.view = [[UIView alloc] initWithFrame:self.view.bounds];
    self.view.backgroundColor = self.myTableView.backgroundColor;
    [self.view addSubview:self.myTableView];
    
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    statusBarView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:statusBarView];
}

@end
