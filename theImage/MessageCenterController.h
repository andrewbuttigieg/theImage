//
//  MessageCenterController.h
//  theImage
//
//  Created by Andrew Buttigieg on 2/10/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCenterController : UITableViewController

@property (nonatomic, strong) NSMutableArray *dateForTable;
@property (nonatomic, strong) NSMutableArray *imageForTable;
@property (nonatomic, strong) NSMutableArray *textForTable;
@property (nonatomic, strong) NSMutableArray *nameForTable;
@property (nonatomic, strong) NSMutableArray *userIDForTable;
@property (strong, nonatomic) IBOutlet UIView *myData;

@end
