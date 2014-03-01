//
//  MessageViewController.m
//  theImage
//
//  Created by Andrew Buttigieg on 2/25/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import "MessageViewController.h"

@interface MessageViewController ()
    @property (readonly, nonatomic) UIView *container;
    @property (readonly, nonatomic) PHFComposeBarView *composeBarView;
    @property (readonly, nonatomic) UIScrollView *textView;
    @property (readonly, nonatomic) UIScrollView *mcontainer;

@end

CGRect const kInitialViewFrame = { 0.0f, 0.0f, 320.0f, 480.0f };

@implementation MessageViewController

static float top = 5;

+ (float) top{
    return top;
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

- (void)loadView {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillToggle:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillToggle:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    UIScrollView *view = [[UIScrollView alloc] initWithFrame:kInitialViewFrame];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    UIView *container = [self container];
    UIScrollView *mcontainer = [self mcontainer];

    [mcontainer setBackgroundColor:[UIColor colorWithHue:106.0f/360.0f saturation:0.81f brightness:0.99f alpha:1]];
    [container addSubview:[self textView]];
    [container addSubview:[self composeBarView]];
    
    [view addSubview:container];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    [self setView:view];
    
    [self appendTextToTextView: @"You are really good keeper" :false];
    /*
    UIView *bubbleView = [[UIView alloc] initWithFrame:CGRectMake(80.0f, 90.0f, 220.0f, 40.0f)];;
    [bubbleView setBackgroundColor:[UIColor colorWithRed:0.0f green:1.0f blue:0.0f alpha:1]];
    
    //the text to add to the bubble
    UITextView *textViewInner = [[UITextView alloc] initWithFrame:CGRectMake(10.0f, 5.0f, 200.0f, 20.0f)];
    [textViewInner setBackgroundColor:[UIColor colorWithRed:0.0f green:1.0f blue:0.0f alpha:1]];
    [textViewInner setTextColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1]];
    [textViewInner setFont:[UIFont systemFontOfSize:[UIFont labelFontSize]]];
    textViewInner.text = @"I like you playing style!";
    [textViewInner sizeToFit];
    [bubbleView addSubview:textViewInner];
    
    [[bubbleView layer] setCornerRadius:20.0f];
    
    //put the bubble in the right place
    bubbleView.frame=CGRectMake(10, top, textViewInner.frame.size.width + 20, textViewInner.frame.size.height + 10);
    
    //where to put the text
    top = 0 + textViewInner.frame.size.height + 20;
    [self.textView addSubview:bubbleView];*/
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

//called when we press send on the keyboard
- (void)composeBarViewDidPressButton:(PHFComposeBarView *)composeBarView {
//    CGRectMake
    //left
    //top
    //width
    //height
    
    [self appendTextToTextView: [composeBarView text] :true];
    //clear the typing area
    [composeBarView setText:@"" animated:YES];
    [composeBarView resignFirstResponder];
    //////////
    //lets us scroll and hold it
    self.textView.userInteractionEnabled=YES;
    [self.textView setScrollEnabled:YES];
}

/*
- (void)composeBarViewDidPressUtilityButton:(PHFComposeBarView *)composeBarView {
    [self prependTextToTextView:@"Utility button pressed"];
}*/

- (void)composeBarView:(PHFComposeBarView *)composeBarView
   willChangeFromFrame:(CGRect)startFrame
               toFrame:(CGRect)endFrame
              duration:(NSTimeInterval)duration
        animationCurve:(UIViewAnimationCurve)animationCurve
{
    //[self prependTextToTextView:[NSString stringWithFormat:@"Height changing by %d", (NSInteger)(endFrame.size.height - startFrame.size.height)]];
    UIEdgeInsets insets = UIEdgeInsetsMake(0.0f, 0.0f, endFrame.size.height, 0.0f);
    UITextView *textView = [self textView];
    [textView setContentInset:insets];
    [textView setScrollIndicatorInsets:insets];
}

- (void)composeBarView:(PHFComposeBarView *)composeBarView
    didChangeFromFrame:(CGRect)startFrame
               toFrame:(CGRect)endFrame
{
    //[self prependTextToTextView:@"Height changed"];
}

- (void)appendTextToTextView:(NSString *)text :(bool)MeOwner {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *bubbleView = [[UIView alloc] initWithFrame:CGRectMake(80.0f, 90.0f, 220.0f, 40.0f)];
        
        
        //the text to add to the bubble
        UITextView *textViewInner = [[UITextView alloc] initWithFrame:CGRectMake(10.0f, 5.0f, 200.0f, 20.0f)];
        
        if (MeOwner){
            [bubbleView setBackgroundColor:[UIColor colorWithHue:206.0f/360.0f saturation:0.81f brightness:0.99f alpha:1]];
            [textViewInner setBackgroundColor:[UIColor colorWithHue:206.0f/360.0f saturation:0.81f brightness:0.99f alpha:0]];
        }
        else{
            [bubbleView setBackgroundColor:[UIColor colorWithRed:0.0f green:1.0f blue:0.0f alpha:1]];
            [textViewInner setBackgroundColor:[UIColor colorWithRed:0.0f green:1.0f blue:0.0f alpha:1]];
        }
        
        [textViewInner setTextColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1]];
        [textViewInner setFont:[UIFont systemFontOfSize:[UIFont labelFontSize]]];
        textViewInner.text = text;
        textViewInner.editable = false;
        [textViewInner sizeToFit];
        [bubbleView addSubview:textViewInner];
        
        [[bubbleView layer] setCornerRadius:20.0f];
        //where to put our bubble
        CGRect screenBound = [[UIScreen mainScreen] bounds];
        CGSize screenSize = screenBound.size;
        CGFloat screenWidth = screenSize.width;
        
        float left = (screenWidth - (textViewInner.frame.size.width + 30));
        
        if (!MeOwner){
            left = 5.0f;
        }
        //put the bubble in the right place
        bubbleView.frame=CGRectMake(left, top, textViewInner.frame.size.width + 20, textViewInner.frame.size.height + 10);
        
        //where to put the text
        top = top + textViewInner.frame.size.height + 20;
        [self.textView addSubview:bubbleView];
        
       
        //set the scroll of the view
        self.textView.contentSize = CGSizeMake(320, top);
        [self.textView setContentSize:(CGSizeMake(320, top))];
    });
}

/*
- (void)prependTextToTextView:(NSString *)text {
    NSString *newText = [text stringByAppendingFormat:@"\n\n%@", [[self textView] text]];
    [[self textView] setText:newText];
}
*/
@synthesize mcontainer = _mcontainer;
- (UIScrollView *)mcontainer {
    if (!_mcontainer) {
        CGRect frame = CGRectMake(0.0f,
                                  0.0f,
                                  kInitialViewFrame.size.width,
                                  kInitialViewFrame.size.height - PHFComposeBarViewInitialHeight);
        _mcontainer = [[UIScrollView alloc] initWithFrame:frame];
        
        [_mcontainer setBackgroundColor:[UIColor colorWithHue:106.0f/360.0f saturation:0.81f brightness:0.99f alpha:1]];
        //[_mcontainer setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    }
    
    return _mcontainer;
}

@synthesize container = _container;
- (UIView *)container {
    if (!_container) {
        _container = [[UIView alloc] initWithFrame:kInitialViewFrame];
        [_container setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    }
    
    return _container;
}

@synthesize composeBarView = _composeBarView;
- (PHFComposeBarView *)composeBarView {
    if (!_composeBarView) {
        CGRect frame = CGRectMake(0.0f,
                                  kInitialViewFrame.size.height - PHFComposeBarViewInitialHeight,
                                  kInitialViewFrame.size.width,
                                  PHFComposeBarViewInitialHeight);
        _composeBarView = [[PHFComposeBarView alloc] initWithFrame:frame];
        [_composeBarView setMaxCharCount:160];
        [_composeBarView setMaxLinesCount:5];
        [_composeBarView setPlaceholder:@"Type something..."];
        [_composeBarView setUtilityButtonImage:[UIImage imageNamed:@"Camera"]];
        [_composeBarView setDelegate:self];
    }
    
    return _composeBarView;
}

@synthesize textView = _textView;
- (UIScrollView *)textView {
    if (!_textView) {
        CGRect frame = CGRectMake(0.0f,
                                  20.0f,
                                  kInitialViewFrame.size.width,
                                  kInitialViewFrame.size.height - 20.0f);
        _textView = [[UIScrollView alloc] initWithFrame:frame];
        [_textView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
     //   [_textView setEditable:NO];
        [_textView setBackgroundColor:[UIColor clearColor]];
        [_textView setAlwaysBounceVertical:YES];
     //   [_textView setFont:[UIFont systemFontOfSize:[UIFont labelFontSize]]];
        UIEdgeInsets insets = UIEdgeInsetsMake(0.0f, 0.0f, PHFComposeBarViewInitialHeight, 0.0f);
        [_textView setContentInset:insets];
        [_textView setScrollIndicatorInsets:insets];
     //   [_textView setText:@"Welcome to the Demo!\n\nThis is just some placeholder text to give you a better feeling of how the compose bar can be used along other components."];
 
     /*   UIView *bubbleView = [[UIView alloc] initWithFrame:CGRectMake(80.0f, 480.0f, 220.0f, 60.0f)];
        [bubbleView setBackgroundColor:[UIColor colorWithHue:206.0f/360.0f saturation:0.81f brightness:0.99f alpha:1]];
        [[bubbleView layer] setCornerRadius:25.0f];
        [_textView addSubview:bubbleView];*/
    }
    
    return _textView;
}
@end
