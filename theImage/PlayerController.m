//
//  PlayerController.m
//  theImage
//
//  Created by Andrew Buttigieg on 1/8/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import "PlayerController.h"
#import "ViewController.h"
#import "MessageViewController.h"

@interface PlayerController ()

@end

@implementation PlayerController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    controller.name = @"name";
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


- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.acceptFriend.a;

//    self.title =
    //self.name.text = [NSString stringWithFormat:@"%d hello!", self.playerID];
    
    
    
    NSString *empty = [NSString stringWithFormat:@""];
    self.name.text = empty;
    self.postion.text = empty;
    self.weight.text = empty;
    self.height.text = empty;
    
    /*
    NSString *urlAsString = [NSString stringWithFormat:@"http://newfootballers.com/get_user.php"];
    NSURL *url = [[NSURL alloc] initWithString:urlAsString];
    NSLog(@"%@", urlAsString);
  */
    int p = (int)self.playerID;
    int p2 = ViewController.playerID;
    
    if (p == p2){
        self.playerInteract.enabled = FALSE;
    }
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://newfootballers.com/get_user.php/"]];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [request setHTTPBody:[[NSString stringWithFormat:@"u=%d", p]dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    //NSError *error = nil; NSURLResponse *response = nil;
//    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            //[self.delegate fetchingGroupsFailedWithError:error];
        } else {
            //[self.delegate receivedGroupsJSON:data];
            //NSError *localError = nil;
            NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                                        options:0
                                                                          error:&error];
            for(NSDictionary *dictionary in jsonArray)
            {
                //NSString *imageURL = [dictionary objectForKey:@"PhotoURL"];
                NSLog(@"%@", jsonArray);

                NSDictionary *friendsD = [dictionary valueForKey:@"Friends"];
                
                
                //get you friends
              /*  dispatch_async(dispatch_get_main_queue(), ^{
                    int total = 0;
                    for (id key in friendsD) {
                        NSDictionary *anObject = [friendsD objectForKey:key];
                        NSLog(@"%@", anObject);
                    
                        NSString *imageURL = [anObject objectForKey:@"PhotoURL"];
                        NSLog(@"%@", imageURL);
                        
                        
                        UIImage *image;
                        
                        if ([imageURL length] > 5){
                            image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
                        }
                        else{
                            //default image
                            image = [UIImage imageNamed:@"player.png"];
                        }
                        UIImageView *iv = [[UIImageView alloc] initWithImage:image];
                        //CGRect frame;
                        iv.frame=CGRectMake(total * 106, 20, 106,106);
                        iv.tag = [[anObject objectForKey:@"UserID"] intValue];
                        //UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
                        //[iv addGestureRecognizer:singleTap];
                        [iv setMultipleTouchEnabled:YES];
                        [iv setUserInteractionEnabled:YES];
                    
                        total++;
                        [self.playerConnectionView addSubview:iv];
               
                    [self.playerConnectionView setContentSize:(CGSizeMake(total * 106, 206))];
                        self.playerConnectionView.backgroundColor=[UIColor brownColor];
                    self.playerConnectionView.userInteractionEnabled=YES;
                    [self.playerConnectionView setScrollEnabled:YES];

                    }
                });*/
                
                NSDictionary *theUserD = [dictionary valueForKey:@"User"];
                NSArray *theUser = [theUserD valueForKey:@"0"];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //get the player information
                    self.playerName.text = [NSString stringWithFormat:@"%@ %@", [theUser valueForKey:@"Firstname"], [theUser valueForKey:@"Lastname"]];
                    self.height.text = [theUser valueForKey:@"Height"];
                    self.weight.text = [theUser valueForKey:@"Weight"];
                    self.postion.text = [theUser valueForKey:@"Position"];
                    self.aboutLabel.text = [theUser valueForKey:@"About"];
                    
                    self.aboutLabel.numberOfLines = 0;
                    [self.aboutLabel sizeToFit];
                    
                    int accepted = -1;
                    if ([theUser valueForKey:@"Accepted"] != nil){
                        accepted = [[theUser valueForKey:@"Accepted"] intValue];
                    }
                    //////
                    int youPending = -1;
                    if ([theUser valueForKey:@"YouPending"] != nil){
                        youPending = [[theUser valueForKey:@"YouPending"] intValue];
                    }
                    
                    if (accepted == 0 || accepted == 1 || accepted == 2){
                        //cannot add to friend anymore
                        //self.addFriendButton.hidden = TRUE;
                    }
                    else{
                        self.playerInteract.title = @"Connect";
                        self.playerInteract.enabled = TRUE;
                    }
                    
                    if (accepted ==1){
                        //you are a friend
                        //self.areFriend.hidden = FALSE;
                        self.playerInteract.enabled = FALSE;
                        self.playerInteract.title = @"Friends";
                        //self.message.hidden = FALSE;
                    }
                    else{
                        //you are not friend yet
                    }
                    if (accepted == 0 && youPending != 1){
                        //
                        self.playerInteract.enabled = FALSE;
                        self.playerInteract.title = @"Requested";
                        //self.reqWaiting.hidden = FALSE;
                        self.navigationItem.leftBarButtonItem = nil;
                    }
                    else if (accepted == 0 && youPending == 1){
                        //not a friend yet, but req there
                        
                        self.playerInteract.enabled = TRUE;
                        self.playerInteract.title = @"Respond";
                       // self.acceptFriend.hidden = FALSE;
                        /*
                        
                        self.reqWaiting.hidden = TRUE;
                        self.beFriendLabel.hidden = FALSE;
                        self.acceptFriend.hidden = FALSE;
                        self.dontWantToFriend.hidden = FALSE;*/
                    }
                    else{
                        self.navigationItem.leftBarButtonItem = nil;
                        /*self.beFriendLabel.hidden = TRUE;
                        self.acceptFriend.hidden = TRUE;
                        self.dontWantToFriend.hidden = TRUE;*/
                    }
                    
                    
                    //get the player image
                    NSString *imageURL = [theUser valueForKey:@"PhotoURL"];
                    
                    
                    if ([imageURL length] > 5){
                        self.playerImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];

                    }
                    else{
                        //default image
                        self.playerImage.image = [UIImage imageNamed:@"player.png"];
                    }
                });
                
                
                //friend people
                dispatch_async(dispatch_get_main_queue(), ^{
                    int y;
                    int x = 10;
                    
                    int total = 0;
                    y = self.aboutLabel.frame.origin.y + self.aboutLabel.frame.size.height + 10;
                    UIScrollView *secondScroll=[[UIScrollView alloc]initWithFrame:CGRectMake(x, y, 320, 150)];
                    //to enable scrolling content size is kept more the 320
                    //                secondScroll.backgroundColor=[UIColor greenColor];
                    
                    for (id key in friendsD)
                    {
                        NSDictionary *anObject = [friendsD objectForKey:key];
                        //[secondScroll release];
                        //[self.scrollview setContentSize:CGSizeMake(320, self.scrollview.contentSize.height+110)];
                        
                        NSString *imageURL = [anObject objectForKey:@"PhotoURL"];
                        NSLog(@"%@", imageURL);
                        
                        UIImage *image;
                        if ([imageURL length] > 5){
                            image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
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
                        iv.frame=CGRectMake(total * 70, 45, 60,60);
                        
                        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(total * 70, 100, 60,30)];
                        lb.textColor = [UIColor colorWithRed:(221.0f/255.0f) green:(221.0f/255.0f) blue:(135.0f/255.0f) alpha:1];
                        lb.text = [anObject objectForKey:@"Firstname"];
                        lb.textAlignment = NSTextAlignmentCenter;
                        
                        
                        [secondScroll addSubview:iv];
                        [secondScroll addSubview:lb];
                        ++total;
                    }
                    [secondScroll setContentSize:CGSizeMake(total * 70, 60)];
                    [self.scrollview addSubview:secondScroll];
                    
                    self.scrollview.contentSize = CGSizeMake(320, y + secondScroll.frame.size.height);
                });
            }
        }
    }];
    
	// Do any additional setup after loading the view.
    self.scrollview.userInteractionEnabled=YES;
    [self.scrollview setScrollEnabled:YES];
    self.scrollview.contentSize = CGSizeMake(320, 700);
    
}

@end
