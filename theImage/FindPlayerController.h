//
//  FindPlayerController.h
//  theImage
//
//  Created by Andrew Buttigieg on 1/8/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FindPlayerController;

/*
@protocol FindPlayerControllerDelegate <NSObject>
- (void)getPlayer:(id)controller playerID:(NSString *)item;
@end
 */

@interface FindPlayerController : UIViewController

- (void)findPeople:(NSInteger) type;

- (IBAction)findScout:(id)sender;
    @property IBOutlet UIScrollView *putThemThere;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *scout;

- (IBAction)findAgent:(id)sender;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *agent;

- (IBAction)findPlayer:(id)sender;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *player;

- (IBAction)reloadExplore:(id)sender;


+ (int)findPlayerID;

@end
