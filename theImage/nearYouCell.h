//
//  nearYouCell.h
//  theImage
//
//  Created by Andrew Buttigieg on 4/21/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface nearYouCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *name;

@property (strong, nonatomic) IBOutlet UILabel *type;

@property (nonatomic, strong) IBOutlet UIImageView *personImage;

@property (strong, nonatomic) IBOutlet UILabel *distance;

@end
