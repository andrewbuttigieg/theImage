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

- (IBAction)addFriend:(id)sender{
    int x = ViewController.playerID;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://newfootballers.com/add_friend.php/"]];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [request setHTTPBody:[[NSString stringWithFormat:@"p1=%d&p2=%d", x, self.playerID]dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init]
            //returningResponse:&response
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *error) {
        
        if (error) {
            //[self.delegate fetchingGroupsFailedWithError:error];
        } else {
            NSLog(@"%@", data);
            
            NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                                        options:0
                                                                          error:&error];
            NSLog(@"%@", jsonArray);
            for(NSDictionary *dictionary in jsonArray)
            {
                //NSLog(@"Data Dictionary is : %@",jsonArray);
                NSString *returned = [jsonArray[0] objectForKey:@"value"];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Your ID!"
                                                                message:[NSString stringWithFormat:@"%@",returned]
                                                               delegate:self
                                                      cancelButtonTitle:@"Go away box"
                                                      otherButtonTitles:nil];
                    [alert show];
                });
            }
            
        }
    }];
}

- (IBAction)noFriendClick:(id)sender {
    int x = ViewController.playerID;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://newfootballers.com/deny_friend.php/"]];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [request setHTTPBody:[[NSString stringWithFormat:@"p1=%d&p2=%d", x, self.playerID]dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init]
     //returningResponse:&response
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *error) {
                               
                               if (error) {
                                   //[self.delegate fetchingGroupsFailedWithError:error];
                               } else {
                                   NSLog(@"%@", data);
                                   
                                   NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                                                               options:0
                                                                                                 error:&error];
                                   NSLog(@"%@", jsonArray);
                                   for(NSDictionary *dictionary in jsonArray)
                                   {
                                       //NSLog(@"Data Dictionary is : %@",jsonArray);
                                       NSString *returned = [jsonArray[0] objectForKey:@"value"];
                                       
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Your ID!"
                                                                                           message:[NSString stringWithFormat:@"%@",returned]
                                                                                          delegate:self
                                                                                 cancelButtonTitle:@"Go away box"
                                                                                 otherButtonTitles:nil];
                                           [alert show];
                                       });
                                   }
                                   
                               }
                               
                           }];
}

- (IBAction)yeahFriendClick:(id)sender {
    int x = ViewController.playerID;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://newfootballers.com/accept_friend.php/"]];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [request setHTTPBody:[[NSString stringWithFormat:@"p1=%d&p2=%d", x, self.playerID]dataUsingEncoding:NSUTF8StringEncoding]];
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
                                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Your ID!"
                                                                                           message:[NSString stringWithFormat:@"%@",returned]
                                                                                          delegate:self
                                                                                 cancelButtonTitle:@"Go away box"
                                                                                 otherButtonTitles:nil];
                                           [alert show];
                                       });
                                   }
                                   
                               }
                               
                           }];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
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
    int p = self.playerID;
    int p2 = ViewController.playerID;
    
    if (p == p2){
        self.addFriendButton.hidden = true;
    }
    else {
        self.addFriendButton.hidden = false;
    }
    
    self.theView.contentSize = CGSizeMake(320, 480);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://newfootballers.com/get_user.php/"]];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [request setHTTPBody:[[NSString stringWithFormat:@"u=%d&me=%d", p, p2]dataUsingEncoding:NSUTF8StringEncoding]];
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
                NSLog(@"Data Dictionary is : %@",dictionary);
                NSString *imageURL = [dictionary objectForKey:@"PhotoURL"];
                NSLog(@"%@", imageURL);
                NSLog(@"%@", [dictionary objectForKey:@"Firstname"]);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //get the player information
                    self.playerName.text = [dictionary objectForKey:@"Firstname"];
                    self.height.text = [dictionary objectForKey:@"Height"];
                    self.weight.text = [dictionary objectForKey:@"Weight"];
                    self.postion.text = [dictionary objectForKey:@"Position"];
                    
                    int accepted = -1;
                    if ([dictionary objectForKey:@"Accepted"] != nil){
                        accepted = [[dictionary objectForKey:@"Accepted"] intValue];
                    }
                    //////
                    int youPending = -1;
                    if ([dictionary objectForKey:@"YouPending"] != nil){
                        youPending = [[dictionary objectForKey:@"YouPending"] intValue];
                    }
                    
                    if (accepted == 0 || accepted == 1 || accepted == 2){
                        self.addFriendButton.hidden = TRUE;
                    }
                    else{
                        self.addFriendButton.hidden = FALSE;
                    }
                    
                    if (accepted ==1){
                        //you are a friend
                        self.areFriend.hidden = FALSE;
                        self.message.hidden = FALSE;
                    }
                    else{
                        //you are not friend yet
                        self.areFriend.hidden = TRUE;
                    }
                    if (accepted == 0 && youPending != 1){
                        //
                        self.reqWaiting.hidden = FALSE;
                    }
                    else if (accepted == 0 && youPending == 1){
                        //not a friend yet, but req there
                        self.reqWaiting.hidden = TRUE;
                        self.beFriendLabel.hidden = FALSE;
                        self.acceptFriend.hidden = FALSE;
                        self.dontWantToFriend.hidden = FALSE;
                    }
                    else{
                        self.beFriendLabel.hidden = TRUE;
                        self.acceptFriend.hidden = TRUE;
                        self.dontWantToFriend.hidden = TRUE;
                    }
                    
                    
                    //get the player image
                    NSString *imageURL = [dictionary objectForKey:@"PhotoURL"];
                    
                    
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
