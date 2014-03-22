//
//  friendCell.h
//  theImage
//
//  Created by Andrew Buttigieg on 3/20/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface friendCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel *name;
@property (nonatomic, strong) IBOutlet UILabel *date;
@property (nonatomic, strong) IBOutlet UILabel *message;
@property (strong, nonatomic) IBOutlet UILabel *type;
@property (nonatomic, strong) IBOutlet UIImageView *personImage;
@property (strong, nonatomic) IBOutlet UIButton *accept;
@property (strong, nonatomic) IBOutlet UIButton *deny;
@end
