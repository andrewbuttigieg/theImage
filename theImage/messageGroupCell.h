//
//  messageGroupCell.h
//  theImage
//
//  Created by Andrew Buttigieg on 2/11/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface messageGroupCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel *name;
@property (nonatomic, strong) IBOutlet UILabel *date;
@property (nonatomic, strong) IBOutlet UILabel *message;
@property (strong, nonatomic) IBOutlet UILabel *type;
@property (nonatomic, strong) IBOutlet UIImageView *personImage;
@end
