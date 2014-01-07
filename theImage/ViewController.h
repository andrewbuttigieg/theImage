//
//  ViewController.h
//  theImage
//
//  Created by Andrew Buttigieg on 1/1/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ViewControllerDetail.h"

@interface ViewController : UIViewController<CLLocationManagerDelegate, ViewControllerDetailDelegate> {
    IBOutlet UIImageView *playerImage;
    IBOutlet UILabel *xLok;
    IBOutlet UILabel *yLok;
    IBOutlet UILabel *playerOnline;
    IBOutlet UILabel *playerName;
    /*IBOutlet UIWebView *videoView;
    NSString *videoURL;
    NSString *videoHTML;*/
}

@property (nonatomic) NSString *returnedItem;

/*@property(nonatomic, retain) IBOutlet UIWebView *videoView;
@property(nonatomic, retain) NSString *videoURL;
@property(nonatomic, retain) NSString *videoHTML;*/

- (IBAction)logoPressed:(id)sender;
- (IBAction)logoPressedTwo:(id)sender;
- (IBAction)getHTTP:(id)sender;

@end