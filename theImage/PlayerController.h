//
//  PlayerController.h
//  theImage
//
//  Created by Andrew Buttigieg on 1/8/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "FindPlayerController.h"

@interface PlayerController : UIViewController/*<FindPlayerControllerDelegate>*/

    @property (nonatomic) NSInteger *playerID;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *weight;
@property (strong, nonatomic) IBOutlet UILabel *height;
@property (strong, nonatomic) IBOutlet UILabel *postion;
@property (strong, nonatomic) IBOutlet UILabel *playerName;
@property (strong, nonatomic) IBOutlet UIImageView *playerImage;
@property (strong, nonatomic) IBOutlet UIButton *addFriendButton;
@property (strong, nonatomic) IBOutlet UILabel *areFriend;
@property (strong, nonatomic) IBOutlet UILabel *reqWaiting;

- (IBAction)addFriend:(id)sender;

@end
