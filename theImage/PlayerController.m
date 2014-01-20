//
//  PlayerController.m
//  theImage
//
//  Created by Andrew Buttigieg on 1/8/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import "PlayerController.h"
#import "ViewController.h"

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

- (IBAction)addFriend:(id)sender{
    int x = ViewController.playerID;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Your ID!"
                                                    message:[NSString stringWithFormat:@"u=%d",x]
                                                   delegate:self
                                          cancelButtonTitle:@"Go away box"
                                          otherButtonTitles:nil];
    [alert show];
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
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://newfootballers.com/get_user.php/"]];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [request setHTTPBody:[[NSString stringWithFormat:@"u=%d",
                           self.playerID]dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    NSError *error = nil; NSURLResponse *response = nil;
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
                    //get the player image
                    NSString *imageURL = [dictionary objectForKey:@"PhotoURL"];
                    self.playerImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
                });
                
                //UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
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
