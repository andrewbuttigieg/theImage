//
//  VideoController.h
//  theImage
//
//  Created by Andrew Buttigieg on 4/12/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoController : UIViewController
    @property (nonatomic) int playerID;
    @property (strong, nonatomic) IBOutlet UIView *addVideo;

- (IBAction)addVideoButton:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *addVideoLink;
@end
