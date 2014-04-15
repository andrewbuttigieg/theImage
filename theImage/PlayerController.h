//
//  PlayerController.h
//  theImage
//
//  Created by Andrew Buttigieg on 1/8/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "FindPlayerController.h"

@interface PlayerController : UIViewController<UIActionSheetDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate>
/*<FindPlayerControllerDelegate>*/

    @property (nonatomic) int playerID;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *weight;
@property (strong, nonatomic) IBOutlet UILabel *height;
@property (strong, nonatomic) IBOutlet UILabel *postion;
@property (strong, nonatomic) IBOutlet UILabel *playerName;
@property (strong, nonatomic) IBOutlet UIImageView *playerImage;
@property (strong, nonatomic) IBOutlet UIScrollView *theView;
@property (strong, nonatomic) IBOutlet UIButton *message;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *playerInteract;
- (IBAction)playerInteractionClick:(id)sender;

- (IBAction)sendMessage:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;
@property (strong, nonatomic) IBOutlet UILabel *aboutLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *playerConnectionView;

- (IBAction)videoClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *videoButton;

@end
