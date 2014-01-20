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
    @property IBOutlet UIScrollView *putThemThere;
@end
