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

@property (nonatomic, strong) NSMutableArray *pageImages;

@property (nonatomic) int playerID;
@property (nonatomic) int meID;
@property (nonatomic) NSString * facebookID;
@property (nonatomic, assign) bool useLocalisation;

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

@property (strong, nonatomic) IBOutlet UIButton *reportButton;
- (IBAction)reportUser:(id)sender;

- (IBAction)sendMessage:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *aboutTitle;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;
@property (strong, nonatomic) IBOutlet UILabel *aboutLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *playerConnectionView;

- (IBAction)videoClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *videoButton;

@property (strong, nonatomic) IBOutlet UILabel *offeringAPlayer;
@property (strong, nonatomic) IBOutlet UILabel *offeringAPlayer_Label;
@property (strong, nonatomic) IBOutlet UILabel *lookingForPlayer;
@property (strong, nonatomic) IBOutlet UILabel *lookingForPlayer_Labe;

@property (strong, nonatomic) IBOutlet UILabel *playingWhere;
@property (strong, nonatomic) IBOutlet UIImageView *heightIcon;
@property (strong, nonatomic) IBOutlet UIImageView *weightIcon;
@property (strong, nonatomic) IBOutlet UILabel *age;

@property (strong, nonatomic) IBOutlet UILabel *userType;
@property (strong, nonatomic) IBOutlet UILabel *location;
@property (strong, nonatomic) IBOutlet UIPageControl *pageView;
- (IBAction)changeScreen:(id)sender;
- (void)changeImage:(int)currentPage;

+ (bool)useLocalisation;
+ (void)setUseLocalisation:(bool) value;
+ (int)playerID;
+ (int)meID;
+ (NSString *)facebookID;
+ (NSString *)deviceToken;
@end
