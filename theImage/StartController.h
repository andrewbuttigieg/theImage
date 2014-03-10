//
//  StartController.h
//  theImage
//
//  Created by Andrew Buttigieg on 3/5/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface StartController : UIViewController

@property (strong, nonatomic) IBOutlet MPMoviePlayerController *moviePlayer;
@property (strong, nonatomic) IBOutlet UIImageView *back;

@end
