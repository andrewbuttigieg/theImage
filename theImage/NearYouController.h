//
//  NearYouController.h
//  theImage
//
//  Created by Andrew Buttigieg on 4/21/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NearYouController : UITableViewController

@property (nonatomic, strong) NSMutableArray *imageForNear;
@property (nonatomic, strong) NSMutableArray *textForNear;
@property (nonatomic, strong) NSMutableArray *nameForNear;
@property (nonatomic, strong) NSMutableArray *userTypeForNear;
@property (nonatomic, strong) NSMutableArray *userIDForNear;
@property (nonatomic, strong) NSMutableArray *locationForNear;

@end
