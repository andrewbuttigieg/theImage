//
//  PlayerController.m
//  theImage
//
//  Created by Andrew Buttigieg on 1/8/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import "AppDelegate.h"
#import "PlayerController.h"
#import "ViewController.h"
#import "MessageViewController.h"
#import "VideoController.h"
#import "PlayerSettingsController.h"
#import "ValidURL.h"

@interface PlayerController ()<PlayerImageDelegate>

@end

@implementation PlayerController

static int playerID = 0;
static int meID = 0;

- (void)changeImage:(int)currentPage{
    if (
        self.pageImages.count > currentPage){
        
        if ([self.pageImages[currentPage] isKindOfClass:[UIImage class]]){
            self.playerImage.image = (UIImage *)self.pageImages[currentPage];
        }
        else{
            //[ValidURL isValidUrl :self.pageImages[currentPage]]){
            self.playerImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.pageImages[currentPage]]]];
        }
    }
    else{
        //default image
        self.playerImage.image = [UIImage imageNamed:@"player.png"];
    }
}

- (IBAction)changeScreen:(id)sender
{
    [self changeImage: [self.pageView currentPage]];
}

bool useLocalisation = true;

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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
   
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
    
        UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Do you want to be friends:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
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
        default:
            break;
    }
}


- (IBAction)sendMessage:(id)sender {
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
                                           self.playerInteract.title = @"Friend";
                                           self.playerInteract.enabled = FALSE;
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
    [self changeImage: [self.pageView currentPage]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
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
                }
                
                if (p == p2){
                    self.playerInteract.enabled = TRUE;
                    self.playerInteract.title = @"Edit";
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
                                
                                self.playingWhere.hidden = false;
                                self.heightIcon.hidden = false;
                                self.weightIcon.hidden = false;
                                
                                if ([[theUser valueForKey:@"VideoCount"] intValue] > 0 || p == p2){
                                    self.videoButton.hidden = FALSE;
                                }
                                else{
                                    self.videoButton.hidden = TRUE;
                                }
                                //get the player information
                                self.playerName.text = [[NSString stringWithFormat:@"%@ %@", [theUser valueForKey:@"Firstname"], [theUser valueForKey:@"Lastname"] ] uppercaseString];
                                
                                name = [theUser valueForKey:@"Firstname"];
                                
                                [self.playerName sizeToFit];
                                
                                CGRect frame = self.age.frame;
                                
                                frame.origin.x = self.playerName.frame.origin.x + self.playerName.frame.size.width + 10;
                                self.age.frame = frame;
                                self.age.hidden = false;
                                
                                self.height.text = [NSString stringWithFormat:@"%.1fcm", [[theUser valueForKey:@"Height"] floatValue]];
                                self.weight.text = [NSString stringWithFormat:@"%.1fkgs", [[theUser valueForKey:@"Weight"] floatValue]];
                                self.postion.text = [theUser valueForKey:@"Position"];
                                
                                if ([self.postion.text isEqualToString:@"0"]){
                                    self.postion.text = @"This user has not choosen their playing position";
                                }
                                
                                if (
                                    [theUser valueForKey:@"UserType"] != [NSNull null] &&
                                    [theUser valueForKey:@"UserType"] != nil){
                                    
                                    if ([[theUser valueForKey:@"UserType"] isEqualToString:@"1"]) {
                                        self.userType.text = @"Player";
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
                                    self.userType.hidden = false;
                                }
                                
                                if (
                                    [theUser valueForKey:@"Country"] != [NSNull null] &&
                                    [theUser valueForKey:@"Country"] != nil){
                                    
                                    self.location.text = [theUser valueForKey:@"Country"];
                                    self.location.hidden = false;
                                }
                                
                                if (
                                    [theUser valueForKey:@"About"] != [NSNull null] &&
                                    [theUser valueForKey:@"About"] != nil){
                                    self.aboutLabel.text = [theUser valueForKey:@"About"];
                                }
                                else if ([self.aboutLabel.text length] < 5)
                                {
                                    self.aboutLabel.text = @"This user has not updated their about section yet";
                                }
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
                                        self.playerInteract.enabled = TRUE;
                                    }
                                    
                                    if (accepted ==1){
                                        //you are a friend
                                        self.playerInteract.enabled = FALSE;
                                        self.playerInteract.title = @"Connected";
                                        //color bar button
                                        [self.playerInteract setTitleTextAttributes:
                                         [NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIColor greenColor], NSForegroundColorAttributeName,nil]
                                                              forState:UIControlStateNormal];

                                        self.message.hidden = FALSE;
                                    }
                                    else{
                                        //you are not friend yet
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
                                        
                                        //bottomBorder.frame = CGRectMake(0.0f, 0.0f, secondScroll.frame.size.width, 1.0f);
                                        
                                        //bottomBorder.backgroundColor = [UIColor colorWithWhite:0.8f
                                        //                                                 alpha:1.0f].CGColor;
                                        [secondScroll.layer addSublayer:bottomBorder];
                                        
                                        /*NSDictionary *temp;
                                        if (i == 0)
                                            temp = playerD;
                                        if (i == 1)
                                            temp = scoutD;
                                        if (i == 2)
                                            temp = agentD;*/
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
                                                if ([ValidURL isValidUrl :imageURL]){                                                    image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
                                                }
                                                else{
                                                    //default image
                                                    image = [UIImage imageNamed:@"player.png"];
                                                }
                                                UIImageView *iv = [[UIImageView alloc] initWithImage:image];
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
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://newfootballers.com/update_user_iospushnotificationid.php/"]];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [request setHTTPBody:[[NSString stringWithFormat:@"iospushnotificationid=%@", appDelegate.theDeviceToken]dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            //[self.delegate fetchingGroupsFailedWithError:error];
        } else {
        }
    }];
}

float imageWidth = 0;
float imageHeight = 0;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat y = -scrollView.contentOffset.y;
    if (y > 64) {
        self.playerImage.frame = CGRectMake(0, scrollView.contentOffset.y + 64, 320 + y - 64, 320 + y - 64);
        self.playerImage.center = CGPointMake(self.view.center.x, self.playerImage.center.y);
    }
    else{
        CGRect frame = self.playerImage.frame;
        frame.size.width = 320;
        frame.size.height = 320;
        self.playerImage.frame = frame;
        self.playerImage.center = CGPointMake(self.view.center.x, self.playerImage.center.y);
        //        self.playerImage.center = CGPointMake(self.view.center.x, self.playerImage.center.y);
    }
}

- (IBAction)videoClick:(id)sender {
    NSString * storyboardName = @"Main_iPhone";
    NSString * viewControllerID = @"VideoController";
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    VideoController * controller = (VideoController *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
    //controller.chattingToID = [o intValue];
    //controller.name = name;
    controller.playerID = self.playerID;
    [self.navigationController pushViewController:controller animated:YES];

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
}


- (void)addItemViewController:
(PlayerSettingsController *)controller didSave :(NSString *)name :(NSString *)lname :(NSString *)about
:(NSString *)age :(NSString *)weight :(NSString *)height :(NSString *)position;
{
    self.playerName.text = [[NSString stringWithFormat:@"%@ %@", name, lname ] uppercaseString];
    if ([about length] < 5){
        self.aboutLabel.text = @"This user has not updated their about section yet";
    }
    else{
        self.aboutLabel.text = about;
    }
    self.height.text = height;
    self.weight.text = weight;
    self.age.text = age;
    self.postion.text = position;
}


@end
