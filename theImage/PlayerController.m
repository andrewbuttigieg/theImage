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
    
    self.theView.contentSize = CGSizeMake(320, 480);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://newfootballers.com/get_user.php/"]];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [request setHTTPBody:[[NSString stringWithFormat:@"u=%d", p, p2]dataUsingEncoding:NSUTF8StringEncoding]];
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
                for (id key in friendsD) {
                    NSDictionary *anObject = [friendsD objectForKey:key];
                    NSLog(@"%@", anObject);
                    /* Do something with anObject. */
                }
                
                NSDictionary *theUserD = [dictionary valueForKey:@"User"];
                NSArray *theUser = [theUserD valueForKey:@"0"];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //get the player information
                    self.playerName.text = [NSString stringWithFormat:@"%@ %@", [theUser valueForKey:@"Firstname"], [theUser valueForKey:@"Lastname"]];
                    self.height.text = [theUser valueForKey:@"Height"];
                    self.weight.text = [theUser valueForKey:@"Weight"];
                    self.postion.text = [theUser valueForKey:@"Position"];
                    
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
            }
        }
    }];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
