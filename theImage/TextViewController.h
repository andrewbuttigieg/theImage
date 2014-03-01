//
//  TextViewController.h
//  theImage
//
//  Created by Andrew Buttigieg on 2/24/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PHFComposeBarView.h"

@interface TextViewController : UIViewController<PHFComposeBarViewDelegate> 
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic) UITextField *activeField;
@property (strong, nonatomic) IBOutlet UITextField *textInput;

@end
