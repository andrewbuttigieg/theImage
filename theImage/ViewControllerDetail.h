//
//  ViewControllerDetail.h
//  theImage
//
//  Created by Andrew Buttigieg on 1/5/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewControllerDetail;
////////
@protocol ViewControllerDetailDelegate <NSObject>
- (void)playerDetailsViewControllerDidSave:
(ViewControllerDetail *)controller;


- (void)addItemViewController:(id)controller didFinishEnteringItem:(NSString *)item;

@end
////////

@interface ViewControllerDetail : UIViewController

@property (strong, nonatomic) IBOutlet UIWebView *webView;

- (IBAction)playVideo:(id)sender;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic) NSString *previouslyTypedInformation;

@property (nonatomic, weak) id <ViewControllerDetailDelegate> delegate;
    - (IBAction)done:(id)sender;
@end
