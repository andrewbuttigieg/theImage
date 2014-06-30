//
//  MessageViewController.h
//  theImage
//
//  Created by Andrew Buttigieg on 2/25/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PHFComposeBarView.h"


@class MessageCenterChange;

@protocol MessageCenterChangeDelegate <NSObject>

- (void)chatting:(id)controller update :(NSString *)date :(NSString *)text
                :(NSString *)unread : (int)idx;
@end

@interface MessageViewController : UIViewController<PHFComposeBarViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *containerMain;
@property (nonatomic) int chattingToID;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *image;
- (IBAction)toggleKeyboard:(id)sender;
+ (float)top;
@property (nonatomic) int tagToUpdate;

@property (nonatomic, weak) id <MessageCenterChangeDelegate> delegate;

@end
