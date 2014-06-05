//
//  MessageCenterController.h
//  theImage
//
//  Created by Andrew Buttigieg on 2/10/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCenterController : UITableViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dateForTable;
@property (nonatomic, strong) NSMutableArray *imageForTable;
@property (nonatomic, strong) NSMutableArray *textForTable;
@property (nonatomic, strong) NSMutableArray *nameForTable;
@property (nonatomic, strong) NSMutableArray *userTypeForTable;
@property (nonatomic, strong) NSMutableArray *userIDForTable;
@property (nonatomic, strong) NSMutableArray *locationForTable;
@property (nonatomic, strong) NSMutableArray *unreadForTable;
@property (strong, nonatomic) IBOutlet UIView *myData;
@property (strong, nonatomic) IBOutlet UITableView *theTable;

@end
