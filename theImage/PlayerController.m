//
//  PlayerController.m
//  theImage
//
//  Created by Andrew Buttigieg on 1/8/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import "AppDelegate.h"
#import "PlayerController.h"
#import "MessageViewController.h"
#import "VideoController.h"
#import "PlayerSettingsController.h"
#import "ValidURL.h"
#import "UIViewController+AMSlideMenu.h"
#import "UIImageView+AFNetworking.h"
#import "FacebookShare.h"
#import "CMFGalleryCell.h"

@interface PlayerController ()<PlayerImageDelegate>

@end

@implementation PlayerController

static int playerID = 0;
static int meID = 0;
static NSString * yourName = @"";
static NSString * otherPlayerName = @"";
static bool player = false;

- (void)changeImage:(int)currentPage{
    if (
        self.pageImages.count > currentPage){
        
        if ([self.pageImages[currentPage] isKindOfClass:[UIImage class]]){
            self.playerImage.image = (UIImage *)self.pageImages[currentPage];
        }
        else{
            if ([ValidURL isValidUrl :self.pageImages[currentPage]]){
                self.playerImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.pageImages[currentPage]]]];
                
//                [self.playerImage setImageWithURL:[NSURL URLWithString:self.pageImages[currentPage]] placeholderImage:[UIImage imageNamed:@"player.png"]];
            }
            else{
                self.playerImage.image = [UIImage imageNamed:@"player.png"];
            }
        }
    }
    else{
        //default image
        self.playerImage.image = [UIImage imageNamed:@"player.png"];
    }
}

- (IBAction)changeScreen:(id)sender
{
    [self changeImage: (int)[self.pageView currentPage]];
}

bool useLocalisation = true;
bool allowFacebook = true;

static NSString* facebookID;
static NSString* name;
static NSString* image;
static NSString* deviceToken;

+ (int) playerID{
    return playerID;
}

+ (int) meID{
    return meID;
}

+ (NSString *)yourName{
    return yourName;
}

+ (NSString*) deviceToken{
    return deviceToken;
}

+ (NSString*) facebookID{
    return facebookID;
}

+ (bool) useLocalisation{
    return useLocalisation;
}

+ (void)setUseLocalisation:(bool) value{
    useLocalisation = value;
}

+ (bool) allowFacebook{
    return allowFacebook;
}

+ (void)setAllowFacebook:(bool) value{
    allowFacebook = value;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touched");
}

-(void) viewWillDisappear:(BOOL)animated{
    self.mainSlideMenu.panGesture.minimumNumberOfTouches = 1;
}

- (void) viewWillAppear:(BOOL)animated
{
    /*if (self.pageView.numberOfPages > 1){
        self.mainSlideMenu.panGesture.minimumNumberOfTouches = 2;
    }*/
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.currentView = @"player";
}

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    UIView *tappedView = [gesture.view hitTest:[gesture locationInView:gesture.view] withEvent:nil];
    /////////
    NSString * storyboardName = @"Main_iPhone";
    NSString * viewControllerID = @"PlayerController";
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    PlayerController * controller = (PlayerController *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
    controller.playerID = tappedView.tag;
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)playerInteractionClick:(id)sender {
    
    if ([self.playerInteract.title isEqualToString:@"Respond"]){
    
        UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Do you want to be connected:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Accept",
                            @"Decline",
                            nil];
        popup.tag = 1;
        [popup showInView:[UIApplication sharedApplication].keyWindow];
    }
    if ([self.playerInteract.title isEqualToString:@"Connect"]){
        self.playerInteract.enabled = FALSE;
        [self addFriend];
    }
    if ([self.playerInteract.title isEqualToString:@"Connected"]){
        UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Do you want to remove this connection:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                                @"Yes",
                                nil];
        popup.tag = 2;
        [popup showInView:[UIApplication sharedApplication].keyWindow];
    }
    if ([self.playerInteract.title isEqualToString:@"Edit"]){
        //edit button
        NSString * storyboardName = @"Main_iPhone";
        NSString * viewControllerID = @"PlayerSettingsController";
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
        PlayerSettingsController * controller = (PlayerSettingsController *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
        
        controller.delegate = self;
        
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (popup.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                    if ([self.playerInteract.title isEqualToString:@"Respond"]){
                        //accept
                        [self acceptFriend];
                    }
                    break;
                case 1:
                    if ([self.playerInteract.title isEqualToString:@"Respond"]){
                        //decline
                        [self declineFriend];
                    }
                    break;
                default:
                    break;
            }
            break;
        }
        case 2:{
            if (buttonIndex == 0) {
                //"Connect"
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://newfootballers.com/remove_friend.php"]];
                [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
                [request setHTTPBody:[[NSString stringWithFormat:@"p2=%d", (int)self.playerID]dataUsingEncoding:NSUTF8StringEncoding]];
                [request setHTTPMethod:@"POST"];
                [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init]
                 //returningResponse:&response
                   completionHandler:^(NSURLResponse *response,
                                       NSData *data,
                                       NSError *error) {
                       
                       if (error) {
                           //[self.delegate fetchingGroupsFailedWithError:error];
                       } else {
                           NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                                                       options:0
                                                                                         error:&error];
                           for(NSDictionary *dictionary in jsonArray)
                           {
                               //NSLog(@"Data Dictionary is : %@",jsonArray);
                               NSString *returned = [jsonArray[0] objectForKey:@"value"];
                               if ([[jsonArray[0] objectForKey:@"accepted"] integerValue] == 1){
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"PlayerCV"
                                               
                                                                                       message:[NSString stringWithFormat:@"%@",returned]
                                                                                      delegate:self
                                                                             cancelButtonTitle:@"Ok"
                                                                             otherButtonTitles:nil];
                                       [alert show];
                                       self.playerInteract.title = @"Connect";
                                       //color bar button
                                       [self.playerInteract setTitleTextAttributes:
                                        [NSDictionary dictionaryWithObjectsAndKeys:
                                         [UIColor colorWithRed:0.0f green:0.674f blue:0.933f alpha:1], NSForegroundColorAttributeName,nil]
                                                                          forState:UIControlStateNormal];

                                       self.playerInteract.enabled = true;
                                   });
                               }
                           }
                           
                       }
                       
                   }];
            }
        }
        case 3:{
            if (buttonIndex == 0) {
                //"Connect"
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://newfootballers.com/report_you.php"]];
                [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
                [request setHTTPBody:[[NSString stringWithFormat:@"u=%d", (int)self.playerID]dataUsingEncoding:NSUTF8StringEncoding]];
                [request setHTTPMethod:@"POST"];
                [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init]
                 //returningResponse:&response
                                       completionHandler:^(NSURLResponse *response,
                                                           NSData *data,
                                                           NSError *error) {
                                           
                                           if (error) {
                                               //[self.delegate fetchingGroupsFailedWithError:error];
                                           } else {
                                               NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                                                                           options:0
                                                                                                             error:&error];
                                               for(NSDictionary *dictionary in jsonArray)
                                               {
                                                   //NSLog(@"Data Dictionary is : %@",jsonArray);
                                                   NSString *returned = [jsonArray[0] objectForKey:@"value"];
                                                   if ([[jsonArray[0] objectForKey:@"accepted"] integerValue] == 1){
                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"PlayerCV"
                                                                                 
                                                                                                           message:[NSString stringWithFormat:@"%@",returned]
                                                                                                          delegate:self
                                                                                                 cancelButtonTitle:@"Ok"
                                                                                                 otherButtonTitles:nil];
                                                           [alert show];
                                                           self.reportButton.enabled = false;
                                                       });
                                                   }
                                               }
                                               
                                           }
                                           
                                       }];
            }
        }
        default:
            break;
    }
}


- (IBAction)reportUser:(id)sender {
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Do you want to report this user:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Yes",
                            nil];
    popup.tag = 3;
    [popup showInView:[UIApplication sharedApplication].keyWindow];
}

- (IBAction)sendMessage:(id)sender {
    
    if (((UIButton *)sender).tag == 2){
        /////////
        NSString * storyboardName = @"Main_iPhone";
        NSString * viewControllerID = @"MessageViewController";
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
        MessageViewController * controller = (MessageViewController *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
        controller.chattingToID = (int)self.playerID;
        controller.name = name;
        controller.image = image;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"PlayerCV"
                                                        message:@"You need to connect with this person to chat first"
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)addFriend{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://newfootballers.com/add_friend.php/"]];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [request setHTTPBody:[[NSString stringWithFormat:@"p2=%d", (int)self.playerID]dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init]
            //returningResponse:&response
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *error) {
        
        if (error) {
            //[self.delegate fetchingGroupsFailedWithError:error];
        } else {
            
            NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                                        options:0
                                                                          error:&error];
            for(NSDictionary *dictionary in jsonArray)
            {
                //NSLog(@"Data Dictionary is : %@",jsonArray);
                NSString *returned = [jsonArray[0] objectForKey:@"value"];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"PlayerCV"
                                                                message:[NSString stringWithFormat:@"%@",returned]
                                                               delegate:self
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
                    [alert show];
                    self.playerInteract.title = @"Requested";
                    self.playerInteract.enabled = FALSE;
                });
            }
            
        }
    }];
}

-(void)declineFriend{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://newfootballers.com/deny_friend.php/"]];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [request setHTTPBody:[[NSString stringWithFormat:@"p2=%d", (int)self.playerID]dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init]
     //returningResponse:&response
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *error) {
                               
                               if (error) {
                                   //[self.delegate fetchingGroupsFailedWithError:error];
                               } else {
                                   NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                                                               options:0
                                                                                                 error:&error];
                                   for(NSDictionary *dictionary in jsonArray)
                                   {
                                       //NSLog(@"Data Dictionary is : %@",jsonArray);
                                       NSString *returned = [jsonArray[0] objectForKey:@"value"];
                                       
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"PlayerCV"
                                                                                           message:[NSString stringWithFormat:@"%@",returned]
                                                                                          delegate:self
                                                                                 cancelButtonTitle:@"Ok"
                                                                                 otherButtonTitles:nil];
                                           [alert show];
                                           self.playerInteract.title = @"Declined";
                                           self.playerInteract.enabled = FALSE;
                                       });
                                   }
                                   
                               }
                               
                           }];
}

-(void)acceptFriend{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://newfootballers.com/accept_friend.php/"]];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [request setHTTPBody:[[NSString stringWithFormat:@"p2=%d", (int)self.playerID]dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init]
     //returningResponse:&response
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *error) {
                               
                               if (error) {
                                   //[self.delegate fetchingGroupsFailedWithError:error];
                               }
                               else {
                                   NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                                                               options:0
                                                                                                 error:&error];
                                   for(NSDictionary *dictionary in jsonArray)
                                   {
                                       NSString *returned = [jsonArray[0] objectForKey:@"value"];
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"PlayerCV"
                                                                                           message:[NSString stringWithFormat:@"%@",returned]
                                                                                          delegate:self
                                                                                 cancelButtonTitle:@"Ok"
                                                                                 otherButtonTitles:nil];
                                           [alert show];
                                           //you are a friend
                                           self.playerInteract.enabled = TRUE;
                                           self.playerInteract.title = @"Connected";
                                           //color bar button
                                           [self.playerInteract setTitleTextAttributes:
                                            [NSDictionary dictionaryWithObjectsAndKeys:
                                             [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1], NSForegroundColorAttributeName,nil]
                                                                              forState:UIControlStateNormal];
                                           
                                           if (self.allowFacebook){
                                               [FacebookShare shareLinkWithShareDialog:[NSString stringWithFormat:@"%@ is now connected with Football %@ %@ on Player CV!", self.yourName, self.userType.text, otherPlayerName]];
                                           }
                                           //Andrew Buttigieg is now connected with Football Agent Clayton Tonna on PlayerCV
                                       });
                                   }
                                   
                               }
                               
                           }];
}

//swipe to the next image if there is one
- (void)swipe:(UISwipeGestureRecognizer *)swipeRecogniser
{
    if ([swipeRecogniser direction] == UISwipeGestureRecognizerDirectionLeft)
    {
        self.pageView.currentPage +=1;
    }
    else if ([swipeRecogniser direction] == UISwipeGestureRecognizerDirectionRight)
    {
        self.pageView.currentPage -=1;
    }
    [self changeImage: (int)[self.pageView currentPage]];
}

- (UIImage *)fixrotation:(UIImage *)image{
    
    if (image.imageOrientation == UIImageOrientationUp) return image;
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (image.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (image.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage), 0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.height,image.size.width), image.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.dataArray = [[NSMutableArray alloc] init];
    [self setupCollectionView];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
//    [self shareLinkWithShareDialog];
    
    player = false;

    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if (appDelegate.messageAPNID > 0){
        NSString * storyboardName = @"Main_iPhone";
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
        MessageViewController *controller = (MessageViewController*)[storyboard instantiateViewControllerWithIdentifier: @"MessageViewController"];
        controller.chattingToID = appDelegate.messageAPNID;
        appDelegate.messageAPNID = 0;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (appDelegate.connectionAPNID > 0){
        
        NSString * storyboardName = @"Main_iPhone";
        NSString * viewControllerID = @"PlayerController";
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
        PlayerController * controller = (PlayerController *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
        controller.playerID = appDelegate.connectionAPNID;
        appDelegate.connectionAPNID = 0;
        [self.navigationController pushViewController:controller animated:YES];
        
/*        self.playerID = ;
        playerID = appDelegate.connectionAPNID;
        appDelegate.connectionAPNID = 0;*/
    }
    
    NSString *empty = [NSString stringWithFormat:@""];
    self.name.text = empty;
    self.postion.text = empty;
    self.weight.text = empty;
    self.height.text = empty;
    
    self.scrollview.delegate = self;
    
    
    NSMutableURLRequest *arequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://newfootballers.com/get_me.php/"]];
    [arequest setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [arequest setHTTPMethod:@"POST"];
    NSError *error = nil; NSURLResponse *response = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:arequest returningResponse:&response error:&error];
    if (error) {
        NSLog(@"Error:%@", error.localizedDescription);
    }
    else {
        NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:0
                                                                      error:&error];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            for(NSDictionary *dictionary in jsonArray)
            {
                NSLog(@"Data Dictionary is : %@", dictionary);
                self.meID = [[dictionary objectForKey:@"UserID"] intValue];   
                meID = [[dictionary objectForKey:@"UserID"] intValue];
                
                self.yourName = [NSString stringWithFormat:@"%@ %@", [dictionary valueForKey:@"Firstname"], [dictionary valueForKey:@"Lastname"] ];
                yourName = [NSString stringWithFormat:@"%@ %@", [dictionary valueForKey:@"Firstname"], [dictionary valueForKey:@"Lastname"] ];
                
                self.facebookID = [dictionary objectForKey:@"FacebookID"];
                facebookID = [dictionary objectForKey:@"FacebookID"];
                
                int p = (int)self.playerID;
                int p2 = self.meID;

                
                if (p <= 0){
                    p = p2;
                    self.playerID = p2;
                    playerID = p2;
                    self.playerInteract.enabled = TRUE;
                    self.playerInteract.title = @"Edit";
                    
                    self.useLocalisation = [[dictionary objectForKey:@"AllowLocalisation"] boolValue];
                    useLocalisation = [[dictionary objectForKey:@"AllowLocalisation"] boolValue];
                    
                    self.allowFacebook = [[dictionary objectForKey:@"AllowFacebook"] boolValue];
                    allowFacebook = [[dictionary objectForKey:@"AllowFacebook"] boolValue];
                    
                }
                
                if (p == p2){
                    self.playerInteract.enabled = TRUE;
                    self.playerInteract.title = @"Edit";
                    self.reportButton.hidden = true;
                }
                else{
                    self.reportButton.hidden = false;
                }
                
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://newfootballers.com/get_user.php/"]];
                [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
                [request setHTTPBody:[[NSString stringWithFormat:@"u=%d", p]dataUsingEncoding:NSUTF8StringEncoding]];
                [request setHTTPMethod:@"POST"];
                
                [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                    
                    if (error) {
                        //[self.delegate fetchingGroupsFailedWithError:error];
                    } else {
                        NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                                                    options:0
                                                                                      error:&error];

                        for(NSDictionary *dictionary in jsonArray)
                        {
                            NSDictionary *theUserD = [dictionary valueForKey:@"User"];
                            NSArray *theUser = [theUserD valueForKey:@"0"];
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                //get the player image
                                NSString *imageURL = [theUser valueForKey:@"PhotoURL"];
                                
                                self.pageImages = [[NSMutableArray alloc] init];
                                
                                int pageCount = 1;
                                if ([ValidURL isValidUrl :imageURL]){
                                    [self.pageImages addObject:imageURL];
                                    self.playerImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
                                    image = imageURL;
                                }
                                else{
                                    //default image
                                    [self.pageImages addObject:[NSNull null]];
                                    self.playerImage.image = [UIImage imageNamed:@"player.png"];
                                    image = @"player.png";
                                }
                                
                                [self.playerImage setUserInteractionEnabled:YES];
                                UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
                                swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
                                [self.playerImage addGestureRecognizer:swipeLeft];
                                
                                UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
                                swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
                                [self.playerImage addGestureRecognizer:swipeRight];
                                
                                imageURL = [theUser valueForKey:@"Photo2"];
                                if ([ValidURL isValidUrl :imageURL]){
                                    [self.pageImages addObject:[theUser valueForKey:@"Photo2"]];
                                    pageCount++;
                                }
                                if ([ValidURL isValidUrl :[theUser valueForKey:@"Photo3"]]){
                                    [self.pageImages addObject:[theUser valueForKey:@"Photo3"]];
                                    pageCount++;
                                }
                                if ([ValidURL isValidUrl :[theUser valueForKey:@"Photo4"]]){
                                    [self.pageImages addObject:[theUser valueForKey:@"Photo4"]];
                                    pageCount++;
                                }
                                if ([ValidURL isValidUrl :[theUser valueForKey:@"Photo5"]]){
                                    [self.pageImages addObject:[theUser valueForKey:@"Photo5"]];
                                    pageCount++;
                                }
                                
                                //set the right amount of balls for images
                                self.pageView.numberOfPages = pageCount;
                                self.pageView.currentPage = 0;
                                
                               /* if (self.pageView.numberOfPages > 1){
                                    self.mainSlideMenu.panGesture.minimumNumberOfTouches = 2;
                                }*/
                                
                                
                                
                                if ([[theUser valueForKey:@"VideoCount"] intValue] > 0 || p == p2){
                                    UIImage *buttonImage = [UIImage imageNamed:@"videoIcon.png"];
                                    [self.videoButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
                                    self.videoButton.tag = 2;
                                }
                                else{
                                    UIImage *buttonImage = [UIImage imageNamed:@"no-videoIcon.png"];
                                    [self.videoButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
                                    self.videoButton.tag = 1;
                                }
                                
                                //self.videoButton.hidden = false;
                                
                                //get the player information
                                self.playerName.text = [[NSString stringWithFormat:@"%@ %@", [theUser valueForKey:@"Firstname"], [theUser valueForKey:@"Lastname"] ] uppercaseString];
                                
                                otherPlayerName = [NSString stringWithFormat:@"%@ %@", [theUser valueForKey:@"Firstname"], [theUser valueForKey:@"Lastname"] ];
                                
                                name = [theUser valueForKey:@"Firstname"];
                                
                                [self.playerName sizeToFit];
                                
                                CGRect frame = self.age.frame;
                                
                                frame.origin.x = self.playerName.frame.origin.x + self.playerName.frame.size.width + 10;
                                self.age.frame = frame;
                                self.age.hidden = false;
                                
                                if ([[theUser valueForKey:@"Height"] floatValue] > 0){
                                    //have height
                                    self.height.text = [NSString stringWithFormat:@"%gcm", [[theUser valueForKey:@"Height"] floatValue]];
                                }
                                else{
                                    self.height.text = @"N/A";
                                }
                                
                                if ([[theUser valueForKey:@"Weight"] floatValue] > 0){
                                    //have weight
                                    self.weight.text = [NSString stringWithFormat:@"%gkgs", [[theUser valueForKey:@"Weight"] floatValue]];
                                }
                                else{
                                    self.weight.text = @"N/A";
                                }
                                
                                self.userType.hidden = false;
                                if (
                                    [theUser valueForKey:@"UserType"] != [NSNull null] &&
                                    [theUser valueForKey:@"UserType"] != nil){
                                    
                                    if ([[theUser valueForKey:@"UserType"] isEqualToString:@"1"]) {
                                        self.userType.text = @"Player";
                                        player = TRUE;
                                    }
                                    else if ([[theUser valueForKey:@"UserType"] isEqualToString:@"2"]) {
                                        self.userType.text = @"Scout";
                                    }
                                    else if ([[theUser valueForKey:@"UserType"] isEqualToString:@"3"]) {
                                        self.userType.text = @"Agent";
                                    }
                                    else if ([[theUser valueForKey:@"UserType"] isEqualToString:@"4"]) {
                                        self.userType.text = @"Coach";
                                    }
                                }
                                
                                if (player){
                                    self.playingWhere.hidden = false;
                                    self.heightIcon.hidden = false;
                                    self.weightIcon.hidden = false;
                                }
                                else{
                                    self.playingWhere.hidden = true;
                                    self.heightIcon.hidden = true;
                                    self.weightIcon.hidden = true;
                                }
                                
                                if (
                                    [theUser valueForKey:@"Country"] != [NSNull null] &&
                                    [theUser valueForKey:@"Country"] != nil){
                                    
                                    self.location.text = [theUser valueForKey:@"Country"];
                                    self.location.hidden = false;
                                }
                                
                                
                                
                                self.aboutLabel.hidden = false;
                                self.aboutTitle.hidden = false;
                                
                                if (
                                    [theUser valueForKey:@"About"] != [NSNull null] &&
                                    [theUser valueForKey:@"About"] != nil &&
                                    [[theUser valueForKey:@"About"] length] > 5){
                                    self.aboutLabel.text = [theUser valueForKey:@"About"];
                                }
                                /*else if ([self.aboutLabel.text length] < 5)
                                {
                                    self.aboutLabel.text = @"This user has not updated their about section yet";
                                }*/
                                else
                                {
                                    self.aboutLabel.text = @"This user has not updated their about section yet";
                                }
                                
                                if ([theUser valueForKey:@"Age"] != [NSNull null])
                                    self.age.text = [theUser valueForKey:@"Age"];
                                else
                                    self.age.text = @"";
                                
                                self.aboutLabel.numberOfLines = 0;
                                [self.aboutLabel sizeToFit];
                                
                                int accepted = -1;
                                if ([theUser valueForKey:@"Accepted"] != nil){
                                    accepted = [[theUser valueForKey:@"Accepted"] intValue];
                                }
                                //////
                                if (p != p2){                                
                                    int youPending = -1;
                                    if ([theUser valueForKey:@"YouPending"] != nil){
                                        youPending = [[theUser valueForKey:@"YouPending"] intValue];
                                    }
                                    
                                    if (accepted == 0 || accepted == 1 || accepted == 2){
                                        //cannot add to friend anymore
                                    }
                                    else{
                                        self.playerInteract.title = @"Connect";
                                        //color bar button
                                        [self.playerInteract setTitleTextAttributes:
                                         [NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIColor colorWithRed:0.0f green:0.674f blue:0.933f alpha:1], NSForegroundColorAttributeName,nil]
                                                                           forState:UIControlStateNormal];
                                        self.playerInteract.enabled = TRUE;
                                    }
                                    
                                    if (accepted ==1){
                                        //you are a friend
                                        self.playerInteract.enabled = TRUE;
                                        self.playerInteract.title = @"Connected";
                                        //color bar button
                                        [self.playerInteract setTitleTextAttributes:
                                         [NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1], NSForegroundColorAttributeName,nil]
                                                              forState:UIControlStateNormal];

                                        UIImage *buttonImage = [UIImage imageNamed:@"chatIcon.png"];
                                        [self.message setBackgroundImage:buttonImage forState:UIControlStateNormal];
                                        self.message.tag = 2;
                                        self.message.hidden = FALSE;
                                    }
                                    else{
                                        //you are not friend yet
                                        UIImage *buttonImage = [UIImage imageNamed:@"no-chatIcon.png"];
                                        [self.message setBackgroundImage:buttonImage forState:UIControlStateNormal];
                                        self.message.tag = 1;
                                        self.message.hidden = FALSE;
                                    }
                                    
                                    if (accepted == 0 && youPending != 1){
                                        //
                                        self.playerInteract.enabled = FALSE;
                                        self.playerInteract.title = @"Requested";
                                        self.navigationItem.leftBarButtonItem = nil;
                                    }
                                    else if (accepted == 0 && youPending == 1){
                                        //not a friend yet, but req there
                                        self.playerInteract.enabled = TRUE;
                                        self.playerInteract.title = @"Respond";
                                        [self.playerInteract setTitleTextAttributes:
                                         [NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIColor colorWithRed:0.0f green:0.674f blue:0.933f alpha:1], NSForegroundColorAttributeName,nil]
                                                                           forState:UIControlStateNormal];
                                    }
                                    else{
                                        self.navigationItem.leftBarButtonItem = nil;
                                    }
                                }
                                
                            });
                            
                            
                            //friend people
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                int newY = 0;
                                for (int i = 0; i < 4; i++){
                                    
                                    int y;
                                    int x = 0;
                                    
                                    int total = 0;
                                    y = self.aboutLabel.frame.origin.y + self.aboutLabel.frame.size.height + 10 + newY;
                                    
                                    //make default..
                                    self.scrollview.contentSize = CGSizeMake(320, y);
                                    
                                    if ([dictionary valueForKey:@"Friends"] != [NSNull null] &&
                                        [dictionary valueForKey:@"Friends"] != nil){
                                    
                                        UIScrollView *secondScroll=[[UIScrollView alloc]initWithFrame:CGRectMake(x, y, 320, 150)];
                                        
                                        CALayer *bottomBorder = [CALayer layer];

                                        [secondScroll.layer addSublayer:bottomBorder];
                                        int playerCount = 0;
                                        int scoutCount = 0;
                                        int agentCount = 0;
                                        int coachCount = 0;
                                        for (id key in [dictionary valueForKey:@"Friends"])
                                        {
                                            NSDictionary *anObject;
                                            
                                            anObject = [[dictionary valueForKey:@"Friends"] objectForKey:key];
                                            
                                            if ([[anObject objectForKey:@"UserType"] intValue] == (i + 1)){
                                            
                                                if (i == 0)
                                                    ++playerCount;
                                                else if (i == 1)
                                                    ++scoutCount;
                                                else if (i == 2)
                                                    ++agentCount;
                                                else if (i == 3)
                                                    ++coachCount;
                                                
                                                NSString *imageURL = [anObject objectForKey:@"PhotoURL"];
                                                imageURL = [imageURL stringByReplacingOccurrencesOfString:@".com/"
                                                                                         withString:@".com/[120]-"];
                                                
                                                UIImage *image;
                                                
                                                //default image
                                                image = [UIImage imageNamed:@"player.png"];
                                                
                                                
                                                UIImageView *iv = [[UIImageView alloc] initWithImage:image];
                                                
                                                if ([ValidURL isValidUrl :imageURL]){
                                                    [iv setImageWithURL:[NSURL URLWithString:imageURL] /*placeholderImage:[UIImage imageNamed:@"player.png" ]*/];
                                                    iv.image = [self fixrotation:iv.image];
                                                }
                                                
                                                iv.layer.cornerRadius = 30.0;
                                                iv.layer.masksToBounds = YES;
                                                iv.layer.borderColor = [UIColor lightGrayColor].CGColor;
                                                iv.layer.borderWidth = 0.3;
                                                iv.frame=CGRectMake(total * 70 + 10, 45, 60,60);
                                                
                                                iv.tag = [[anObject objectForKey:@"UserID"] intValue];
                                                UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
                                                [iv addGestureRecognizer:singleTap];
                                                [iv setMultipleTouchEnabled:YES];
                                                [iv setUserInteractionEnabled:YES];
                                                
                                                UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(total * 70 + 10, 100, 60,30)];
                                                //if (i == 0)
                                                    lb.textColor = [UIColor colorWithRed:(92.0f/255.0f) green:(92.0f/255.0f) blue:(92.0f/255.0f) alpha:1];
                                                lb.text = [anObject objectForKey:@"Firstname"];
                                                lb.textAlignment = NSTextAlignmentCenter;
                                                
                                                
                                                [secondScroll addSubview:iv];
                                                [secondScroll addSubview:lb];
                                                ++total;
                                            }
                                        }
                                        
                                        if (total > 0){
                                            newY += 150;
                                            [secondScroll setContentSize:CGSizeMake(total * 70 + 10, 60)];
                                            
                                            UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 60,30)];
                                            lb.textColor = [UIColor colorWithRed:(180.0f/255.0f) green:(180.0f/255.0f) blue:(180.0f/255.0f) alpha:1];
                                            
                                            [lb setFont:[UIFont systemFontOfSize:15]];
                                            if (i == 0)
                                                lb.text = [NSString stringWithFormat:@"Player Connections (%d)", playerCount];
                                            else if (i == 1)
                                                lb.text = [NSString stringWithFormat:@"Scout Connections (%d)", scoutCount];
                                            else if (i == 2)
                                                lb.text = [NSString stringWithFormat:@"Agent Connections (%d)", agentCount];
                                            else if (i == 3)
                                                lb.text = [NSString stringWithFormat:@"Coach Connections (%d)", coachCount];
                                            [lb sizeToFit];
                                            
                                            lb.textAlignment = NSTextAlignmentLeft;
                                            [secondScroll addSubview:lb];
                                            [self.scrollview addSubview:secondScroll];
                                            
                                            self.scrollview.contentSize = CGSizeMake(320, y + secondScroll.frame.size.height);
                                        }
                                    }
                                }
                                bool lookingForPartner = false;
                                if (
                                    [theUser valueForKey:@"LookingForPartnership"] != [NSNull null] &&
                                    [theUser valueForKey:@"LookingForPartnership"] != nil &&
                                    [[theUser valueForKey:@"LookingForPartnership"] intValue] == 1){
                                    lookingForPartner = true;
                                }
                                
                                bool lookingForPlayer = false;
                                if (
                                    [theUser valueForKey:@"LookingForPlayer"] != [NSNull null] &&
                                    [theUser valueForKey:@"LookingForPlayer"] != nil &&
                                    [[theUser valueForKey:@"LookingForPlayer"] intValue] == 1){
                                    lookingForPlayer = true;
                                }                                
                                
                                [self fixDisplay:[theUser valueForKey:@"Position"]
                                                :lookingForPlayer
                                                :[theUser valueForKey:@"LFPCountry"]
                                                :[theUser valueForKey:@"LFPPosition"]
                                                :lookingForPartner
                                                :[theUser valueForKey:@"PartnerCountry"]];
                                [self.collectionView reloadData];
                            });
                        }
                    }
                }];
                
                // Do any additional setup after loading the view.
                self.scrollview.userInteractionEnabled=YES;
                [self.scrollview setScrollEnabled:YES];
                self.scrollview.contentSize = CGSizeMake(320, 700);
                
                
            }
        });
    }
}

float imageWidth = 0;
float imageHeight = 0;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    /*
    CGFloat y = -scrollView.contentOffset.y;
    
    if (y < 64 && y > 0){
        CGRect frame = self.playerImage.frame;
        frame.size.width = 320;
        frame.size.height = 320;
        self.playerImage.frame = frame;
        self.playerImage.center = CGPointMake(self.view.center.x, self.playerImage.center.y);
        
        frame = self.collectionView.frame;
        self.collectionView.frame = frame;
        self.collectionView.center = CGPointMake(self.view.center.x, self.collectionView.center.y);

        //        self.playerImage.center = CGPointMake(self.view.center.x, self.playerImage.center.y);
    }
    else if (y > 64) {
        self.playerImage.frame = CGRectMake(0, scrollView.contentOffset.y + 64, 320 + y - 64, 320 + y - 64);
        self.playerImage.center = CGPointMake(self.view.center.x, self.playerImage.center.y);
        
        self.collectionView.frame = CGRectMake(0, scrollView.contentOffset.y + 64, 320 + y - 64, 320 + y - 64);
        self.collectionView.center = CGPointMake(self.view.center.x, self.collectionView.center.y);
    }*/
}

- (IBAction)videoClick:(id)sender {
    
    
    if (((UIButton *)sender).tag == 2){
        /////////
        NSString * storyboardName = @"Main_iPhone";
        NSString * viewControllerID = @"VideoController";
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
        VideoController * controller = (VideoController *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
        //controller.chattingToID = [o intValue];
        //controller.name = name;
        controller.playerID = self.playerID;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"PlayerCV"
                                                        message:@"This person does not have videos yet"
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - PlayerImageDelegate

- (void)addItemViewController:

(PlayerSettingsController *)controller uploadedImage:(UIImage *)item :(int)imagePos
{
    //update the image of the player
    //self.playerImage.image = item;
    if (imagePos >= self.pageImages.count){
        [self.pageImages addObject:item];
        self.pageView.numberOfPages = self.pageImages.count;
    }
    else{
        self.pageImages[imagePos] = item;
    }
    if (imagePos == [self.pageView currentPage]){
        self.playerImage.image = item;
    }
    
    [self.collectionView reloadData];
    /*
    if (self.pageView.numberOfPages > 1){
        self.mainSlideMenu.panGesture.minimumNumberOfTouches = 2;
    }
    else{
        self.mainSlideMenu.panGesture.minimumNumberOfTouches = 1;
    }*/
}

- (void)fixDisplay:(NSString *)position
           :(BOOL)lookingForPlayer :(NSString *)lfpCountry :(NSString *)lfpPosition :(BOOL)lookingForPartner
           :(NSString *)lfpartCountry;
{
    if (!player){
        
        self.heightIcon.hidden = TRUE;
        self.weightIcon.hidden = TRUE;
        self.height.hidden = TRUE;
        self.weight.hidden = TRUE;
        self.videoButton.hidden = TRUE;
        
        CGRect frame1 = self.reportButton.frame;
        frame1.origin.x = self.message.frame.origin.x;
        self.reportButton.frame = frame1;
        
        frame1 = self.message.frame;
        frame1.origin.x = self.videoButton.frame.origin.x;
        self.message.frame = frame1;
        
        
        if (
            ![lfpartCountry isEqual:[NSNull null]] &&
            lfpartCountry != nil &&
            [lfpartCountry length] > 0 &&
            lookingForPartner)
        {
            self.offeringAPlayer_Label.hidden = false;
            self.offeringAPlayer.hidden = false;
            self.offeringAPlayer.text = lfpartCountry;
            
            CGRect frame = self.lookingForPlayer_Labe.frame;
            frame.origin.y = self.offeringAPlayer.frame.origin.y + 25;
            self.lookingForPlayer_Labe.frame = frame;
            
            frame = self.lookingForPlayer.frame;
            frame.origin.y = self.lookingForPlayer_Labe.frame.origin.y + 25;
            self.lookingForPlayer.frame = frame;
        }
        else{
            self.offeringAPlayer_Label.hidden = true;
            self.offeringAPlayer.hidden = true;
            //hide it
            CGRect frame = self.lookingForPlayer_Labe.frame;
            frame.origin.y = self.offeringAPlayer_Label.frame.origin.y;
            self.lookingForPlayer_Labe.frame = frame;
            
            frame = self.lookingForPlayer.frame;
            frame.origin.y = self.offeringAPlayer.frame.origin.y;
            self.lookingForPlayer.frame = frame;
        }
        
        if (
            ![lfpCountry isEqual:[NSNull null]] &&
            lfpCountry != nil &&
            [lfpCountry length] > 0 &&
            ![lfpPosition isEqual:[NSNull null]] &&
            lfpPosition != nil &&
            [lfpPosition length] > 0 &&
            lookingForPlayer){
            
            self.lookingForPlayer_Labe.hidden = false;
            self.lookingForPlayer.hidden = false;

            self.lookingForPlayer.text = [NSString stringWithFormat:@"%@ to play in %@", lfpPosition, lfpCountry];
            self.lookingForPlayer.numberOfLines = 0;
            [self.lookingForPlayer sizeToFit];
            
            //telling the next item where to be
            CGRect frame = self.playingWhere.frame;
            frame.origin.y = self.lookingForPlayer.frame.origin.y + self.lookingForPlayer.frame.size.height + 5;
            self.playingWhere.frame = frame;
        }
        else{
            
            self.lookingForPlayer_Labe.hidden = true;
            self.lookingForPlayer.hidden = true;
            
            //telling the next item where to be
            CGRect frame = self.playingWhere.frame;
            frame.origin.y = self.lookingForPlayer_Labe.frame.origin.y;
            self.playingWhere.frame = frame;
            
            frame = self.postion.frame;
            frame.origin.y = self.playingWhere.frame.origin.y + 25;
            self.postion.frame = frame;
        }
        
        CGRect frame = self.postion.frame;
        frame.origin.y = self.playingWhere.frame.origin.y + 25;
        self.postion.frame = frame;
        
        frame = self.aboutTitle.frame;
        frame.origin.y = self.postion.frame.origin.y + 25;
        self.aboutTitle.frame = frame;
        
        frame = self.aboutLabel.frame;
        frame.origin.y = self.aboutTitle.frame.origin.y + 25;
        self.aboutLabel.frame = frame;
    }
    else{
        self.lookingForPlayer.hidden = TRUE;
        self.lookingForPlayer_Labe.hidden = TRUE;
        self.offeringAPlayer.hidden = TRUE;
        self.offeringAPlayer_Label.hidden = TRUE;
        self.videoButton.hidden = false;
        
        //hide it
        CGRect frame = self.playingWhere.frame;
        frame.origin.y = self.offeringAPlayer_Label.frame.origin.y;
        self.playingWhere.frame = frame;
        
        frame = self.postion.frame;
        frame.origin.y = self.offeringAPlayer.frame.origin.y;
        self.postion.frame = frame;
        
        frame = self.aboutTitle.frame;
        frame.origin.y = self.postion.frame.origin.y + 25;
        self.aboutTitle.frame = frame;
        
        frame = self.aboutLabel.frame;
        frame.origin.y = self.aboutTitle.frame.origin.y + 25;
        self.aboutLabel.frame = frame;
    }
    
    if (player){
        if (![position isEqual:[NSNull null]] &&
            position != nil &&
            [position length] > 0 &&
            ![position isEqualToString:@"0"]){
            self.postion.text = position;
        }
        else{
            self.postion.text = @"This user has not chosen their playing position";
        }
        self.postion.numberOfLines = 0;
        [self.postion sizeToFit];
        
        CGRect frame = self.aboutTitle.frame;
        frame.origin.y = self.postion.frame.origin.y + self.postion.frame.size.height + 5;
        self.aboutTitle.frame = frame;
        
        frame = self.aboutLabel.frame;
        frame.origin.y = self.aboutTitle.frame.origin.y + 25;
        self.aboutLabel.frame = frame;
    }
    else{
        self.playingWhere.hidden = TRUE;
        self.postion.hidden = TRUE;
        
        CGRect frame = self.aboutTitle.frame;
        frame.origin.y = self.playingWhere.frame.origin.y;
        self.aboutTitle.frame = frame;
        
        frame = self.aboutLabel.frame;
        frame.origin.y = self.postion.frame.origin.y;
        self.aboutLabel.frame = frame;
    }
    
    int newY = self.aboutLabel.frame.origin.y + self.aboutLabel.frame.size.height + 10;
    
    self.scrollview.contentSize = CGSizeMake(320, newY);
    
    for (UIView* view in self.scrollview.subviews)
    {
        if ([view isKindOfClass:[UIScrollView class]] || [view isKindOfClass:[UIWebView class]])
        {
            CGRect frame = view.frame;
            if (frame.origin.y != 0){
                frame.origin.y = newY;
                view.frame = frame;
                newY += 150;
                self.scrollview.contentSize = CGSizeMake(320, newY);
            }
        }
    }
    CGRect frame = self.collectionView.frame;
    frame.size.height = 320;
    frame.size.width = 320;
    frame.origin.y = 0;
    self.collectionView.frame = frame;
    self.collectionView.hidden = false;
}

- (void)addItemViewController:
(PlayerSettingsController *)controller didSave :(NSString *)name :(NSString *)lname :(NSString *)about
:(NSString *)age :(NSString *)weight :(NSString *)height :(NSString *)position
:(BOOL)lookingForPlayer :(NSString *)lfpCountry :(NSString *)lfpPosition :(BOOL)lookingForPartner
:(NSString *)lfpartCountry;
{
    
    self.playerName.text = [[NSString stringWithFormat:@"%@ %@", name, lname ] uppercaseString];
    if ([about length] < 5){
        self.aboutLabel.text = @"This user has not updated their about section yet";
    }
    else{
        self.aboutLabel.text = about;
    }
//    [self.aboutLabel sizeToFit];
    
    [self fixDisplay:position :lookingForPlayer :lfpCountry :lfpPosition :lookingForPartner :lfpartCountry];
    
    if (
        ![height isEqual:[NSNull null]] && height != nil &&
        ![height isEqualToString:@"0"] && ![height isEqualToString:@""]){
        //have height
        self.height.text = [NSString stringWithFormat:@"%gkgs", [height floatValue]];
    }
    else{
        self.height.text = @"N/A";
    }
    
    if (
        ![weight isEqual:[NSNull null]] && weight != nil &&
        ![weight isEqualToString:@"0"] && ![weight isEqualToString:@""]){
        //have height
        self.weight.text = [NSString stringWithFormat:@"%gkgs", [weight floatValue]];
    }
    else{
        self.weight.text = @"N/A";
    }
    
    self.age.text = age;
}

#pragma mark -
#pragma mark UICollectionView methods

-(void)setupCollectionView {
    [self.collectionView registerClass:[CMFGalleryCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setMinimumInteritemSpacing:0.0f];
    [flowLayout setMinimumLineSpacing:0.0f];
    [self.collectionView setPagingEnabled:YES];
    [self.collectionView setCollectionViewLayout:flowLayout];
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.pageImages count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CMFGalleryCell *cell = (CMFGalleryCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
/*    UIImage *imageName = [self.pageImages objectAtIndex:indexPath.row];
    [cell setImageName:imageName.description];*/
    
    if ([ValidURL isValidUrl :[self.pageImages objectAtIndex:indexPath.row]]){
//        cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self.pageImages objectAtIndex:indexPath.row]]] placeholderImage:[UIImage imageNamed:@"player.png" ]];
        
        NSURL *xxx = [NSURL URLWithString:[self.pageImages objectAtIndex:indexPath.row]];
        [cell.imageView setImageWithURL:xxx placeholderImage:[UIImage imageNamed:@"player.png"]];
        
        //                [self.playerImage setImageWithURL:[NSURL URLWithString:self.pageImages[currentPage]] placeholderImage:[UIImage imageNamed:@"player.png"]];
    }
    else{
        cell.imageView.image = [UIImage imageNamed:@"player.png"];
    }
    //cell.imageView.image = [self.pageImages objectAtIndex:indexPath.row];
    [cell updateCell];
    self.collectionView.hidden = false;
    
    self.pageView.currentPage = indexPath.row;
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.collectionView.frame.size;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
