//
//  VideoController.h
//  theImage
//
//  Created by Andrew Buttigieg on 4/12/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoController : UIViewController<UIActionSheetDelegate>
    @property (nonatomic) int playerID;
    @property (strong, nonatomic) IBOutlet UIView *addVideo;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;

- (IBAction)addVideoButton:(id)sender;
- (NSString *)extractYoutubeID:(NSString *)youtubeURL;

@property (strong, nonatomic) IBOutlet UITextField *addVideoLink;
@end
