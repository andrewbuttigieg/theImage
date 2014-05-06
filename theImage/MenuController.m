//
//  MenuController.m
//  theImage
//
//  Created by Andrew Buttigieg on 3/18/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import "MenuController.h"
#import "MainVC.h"

@interface MenuController() <MainVCDelegate>

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

    NSLog(@"%@", self.navigationController.viewControllers );
    
//    controller.delegate = self;
    MainVC *rootController = (MainVC *)[self.navigationController.viewControllers objectAtIndex: 1];
    rootController.delegate = self;
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

#pragma mark - MainVCDelegate


- (void)MainVCController:(MainVC *)controller countUpdate:(int)chatCount :(int)requestCount
{
    self.chatCount.text = [NSString stringWithFormat:@"%d", chatCount];
    [self.chatCount sizeToFit];
    
    CGRect frame = self.chatCount.frame;
    
    frame.size.width = frame.size.width + 10;
    frame.size.height = frame.size.height + 10;
    
    self.chatCount.frame = frame;
    self.chatCount.layer.cornerRadius = 7.0;
    if (chatCount > 0)
        self.chatCount.hidden = FALSE;
    else
        self.chatCount.hidden = TRUE;
    
    
    self.reqCount.text = [NSString stringWithFormat:@"%d", requestCount];
    [self.reqCount sizeToFit];
    
    frame = self.reqCount.frame;
    
    frame.size.width = frame.size.width + 10;
    frame.size.height = frame.size.height + 10;
    
    self.reqCount.frame = frame;
    self.reqCount.layer.cornerRadius = 7.0;
    if (requestCount > 0)
        self.reqCount.hidden = FALSE;
    else
        self.reqCount.hidden = TRUE;

}

@end
