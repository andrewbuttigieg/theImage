//
//  VideoController.m
//  theImage
//
//  Created by Andrew Buttigieg on 4/12/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import "VideoController.h"
#import "ViewController.h"

@interface VideoController ()

@end

@implementation VideoController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.playerID == ViewController.playerID){
        self.addVideo.hidden = false;    
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://newfootballers.com/get_videos.php/"]];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [request setHTTPBody:[[NSString stringWithFormat:@"userid=%d", self.playerID]dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    //NSError *error = nil; NSURLResponse *response = nil;
    //    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            
        } else {
            NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                                        options:0
                                                                          error:&error];
            for(NSDictionary *dictionary in jsonArray)
            {
                if ([dictionary objectForKey:@"accepted"])
                {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"PlayerCV"
                                                                   message: [dictionary objectForKey:@"value"]
                                                                  delegate: self
                                                         cancelButtonTitle:@"Ok"
                                                         otherButtonTitles:nil];
                    
                    
                    [alert show];
                }
                NSLog(@"%@", dictionary);
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

- (BOOL)isValidUrl:(NSString *)urlString{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    return [NSURLConnection canHandleRequest:request];
}

- (IBAction)addVideoButton:(id)sender {
    if ([self isValidUrl:self.addVideoLink.text]){
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://newfootballers.com/add_video.php/"]];
        [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
        [request setHTTPBody:[[NSString stringWithFormat:@"url=%@&comment=%@", self.addVideoLink.text, @"-"]dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPMethod:@"POST"];
        //NSError *error = nil; NSURLResponse *response = nil;
        //    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            
            if (error) {

            } else {
                NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                                            options:0
                                                                              error:&error];
                for(NSDictionary *dictionary in jsonArray)
                {
                    NSLog(@"%@", dictionary);
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"PlayerCV"
                                                                   message: @"Video added"
                                                                  delegate: self
                                                         cancelButtonTitle:@"Cancel"
                                                         otherButtonTitles:@"OK",nil];
                    
                    
                    [alert show];
                }
            }
        }];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"PlayerCV"
                                                        message:[NSString stringWithFormat:@"%@",@"That is not a valid link"]
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    }
}
@end
