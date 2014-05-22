//
//  MenuController.h
//  theImage
//
//  Created by Andrew Buttigieg on 3/18/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMSlideMenuMainViewController.h"


@interface MenuController : AMSlideMenuLeftTableViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *chatCount;
@property (strong, nonatomic) IBOutlet UITableView *theTable;

@property (strong, nonatomic) IBOutlet UILabel *reqCount;
@end
