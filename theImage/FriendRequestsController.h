//
//  FriendRequestsController.h
//  theImage
//
//  Created by Andrew Buttigieg on 3/20/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendRequestsController : UITableViewController

@property (nonatomic, strong) NSMutableArray *dateForFR;
@property (nonatomic, strong) NSMutableArray *imageForFR;
@property (nonatomic, strong) NSMutableArray *textForFR;
@property (nonatomic, strong) NSMutableArray *nameForFR;
@property (nonatomic, strong) NSMutableArray *userTypeForFR;
@property (nonatomic, strong) NSMutableArray *userIDForFR;
@property (strong, nonatomic) IBOutlet UIImageView *accept;

@end
