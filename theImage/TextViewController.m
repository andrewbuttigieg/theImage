//
//  TextViewController.m
//  theImage
//
//  Created by Andrew Buttigieg on 2/24/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import "TextViewController.h"

@interface TextViewController ()
@property (readonly, nonatomic) UIView *container;
@property (readonly, nonatomic) PHFComposeBarView *composeBarView;
@property (readonly, nonatomic) UITextView *textView;
@end

CGRect const kInitialViewFrame = { 0.0f, 0.0f, 320.0f, 480.0f };

@implementation TextViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init {
    self = [super init];
    
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillToggle:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillToggle:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    
    return self;
}

- (void)keyboardWillToggle:(NSNotification *)notification {
    NSDictionary* userInfo = [notification userInfo];
    NSTimeInterval duration;
    UIViewAnimationCurve animationCurve;
    CGRect startFrame;
    CGRect endFrame;
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&duration];
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey]    getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey]        getValue:&startFrame];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]          getValue:&endFrame];
    
    NSInteger signCorrection = 1;
    if (startFrame.origin.y < 0 || startFrame.origin.x < 0 || endFrame.origin.y < 0 || endFrame.origin.x < 0)
        signCorrection = -1;
    
    CGFloat widthChange  = (endFrame.origin.x - startFrame.origin.x) * signCorrection;
    CGFloat heightChange = (endFrame.origin.y - startFrame.origin.y) * signCorrection;
    
    CGFloat sizeChange = UIInterfaceOrientationIsLandscape([self interfaceOrientation]) ? widthChange : heightChange;
    
    CGRect newContainerFrame = [[self container] frame];
    newContainerFrame.size.height += sizeChange;
    
    [UIView animateWithDuration:duration
                          delay:0
                        options:(animationCurve << 16)|UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [[self container] setFrame:newContainerFrame];
                     }
                     completion:NULL];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

/*
 - (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self registerForKeyboardNotifications];
    
   _activeField = self.textInput;*/
    
    /*CGRect viewBounds = [[self view] bounds];
    CGRect frame = CGRectMake(0.0f,
                              viewBounds.size.height - PHFComposeBarViewInitialHeight,
                              viewBounds.size.width,
                              PHFComposeBarViewInitialHeight);
    PHFComposeBarView *composeBarView = [[PHFComposeBarView alloc] initWithFrame:frame];
    [composeBarView setMaxCharCount:160];
    [composeBarView setMaxLinesCount:5];
    [composeBarView setPlaceholder:@"Type something..."];
    [composeBarView setUtilityButtonImage:[UIImage imageNamed:@"Camera"]];
    [composeBarView setDelegate:self];
    
	// Do any additional setup after loading the view.
}*/

- (void)loadView {
    UIView *view = [[UIView alloc] initWithFrame:kInitialViewFrame];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    UIView *container = [self container];
    [container addSubview:[self textView]];
    [container addSubview:[self composeBarView]];
    [view addSubview:container];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    [self setView:view];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}



// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}


// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
 /*   _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
 */
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    NSLog(@"x %f", _activeField.frame.origin.x);
    NSLog(@"y %f", _activeField.frame.origin.y);
    if (!CGRectContainsPoint(aRect, _activeField.frame.origin) ) {
    //    [self.scrollView scrollRectToVisible:_activeField.frame animated:YES];
    }
    
    
    
    
    //CGRect aRect = self.view.frame;
    //aRect.size.height -= kbSize.height;
    //CGPoint origin = _activeField.frame.origin;
    //origin.y -= _scrollView.contentOffset.y;
    //if (!CGRectContainsPoint(aRect, origin) ) {
    //    CGPoint scrollPoint = CGPointMake(0.0, _activeField.frame.origin.y-(aRect.size.height));
    //    [self.scrollView setContentOffset:scrollPoint animated:YES];
    //}
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    /*
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;*/
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _activeField = nil;
}

@end
