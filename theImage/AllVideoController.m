//
//  AllVideoController.m
//  theImage
//
//  Created by Andrew Buttigieg on 4/24/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import "AllVideoController.h"
#import "PlayerController.h"

@interface AllVideoController ()

@end

@implementation AllVideoController


static float top = 0;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)load:(UIRefreshControl *)refreshControl{
    //int me = ViewController.playerID;
    
    top = 0.0;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://newfootballers.com/get_all_videos.php/"]];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    //[request setHTTPBody:[[NSString stringWithFormat:@"u=%d", PlayerController.meID]dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            //[self.delegate fetchingGroupsFailedWithError:error];
        } else {
            NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                                        options:0
                                                                          error:&error];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSLog(@"Data Dictionary is : %@",jsonArray);
                
                for(NSDictionary *dictionary in jsonArray)
                {
                    
                    /*[self.nameForTable addObject:[dictionary objectForKey:@"Firstname"]];
                    [self.imageForTable addObject:[dictionary objectForKey:@"PhotoURL"]];
                    
                    
                    [self.textForTable addObject:[dictionary objectForKey:@"Text"]];
                    [self.userTypeForTable addObject:[dictionary objectForKey:@"UserType"]];
                    [self.userIDForTable addObject:[dictionary objectForKey:@"UserID"]];*/
                    

                        
                        /* NSString *newHTML = @"<html>\
                         <style>body{padding:0;margin:0;}</style>\
                         <iframe width=\"300\" height=\"200\" src=\"http://www.youtube.com/embed/zL0CCsdS1cE?autoplay=1\" frameborder=\"0\" allowfullscreen></iframe>\
                         </html>";*/
                        
                        //NSString *newHTML = [NSString stringWithFormat:@"<html>\
                        <style>body{padding:0;margin:0;background-color:red}</style>\
                        <iframe width=\"300\" height=\"200\" src=\"%@\" frameborder=\"0\" allowfullscreen></iframe>\
                        </html>", [dictionary objectForKey:@"URL"]];
                        //http://www.youtube.com/embed/zL0CCsdS1cE?autoplay=1
                        
                        //[self.webView loadHTMLString:newHTML baseURL:nil];
                        
                        CGRect webFrame = CGRectMake(00.0, 0.0, 320.0, 200.0);
                        //int tempIndex = (int)([[dictionary objectForKey:@"URL"] rangeOfString:@"/" options:NSBackwardsSearch].location);
                        //NSString *newStr = [[dictionary objectForKey:@"URL"] substringFromIndex:tempIndex];
                        NSString *theURL = [dictionary objectForKey:@"URL"];
                        theURL = [theURL stringByReplacingOccurrencesOfString:@"watch?v=" withString:@"embed/"];
                        
                        //the video
                        NSURL *url = [NSURL URLWithString:theURL];
                        NSURLRequest *req = [NSURLRequest requestWithURL:url];
                        UIWebView *bubbleView = [[UIWebView alloc] initWithFrame:webFrame];
                        bubbleView.backgroundColor = [UIColor blackColor];
                        bubbleView.frame=CGRectMake(0, top, 320, 200);
                        [bubbleView loadRequest:req];
                        //delete button
                        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                        [button addTarget:self action:@selector(deleteVideo:) forControlEvents:UIControlEventTouchUpInside];
                        button.tag = [[dictionary objectForKey:@"VideoID"] intValue];
                        [button setTitle:@"Delete" forState:UIControlStateNormal];
                        button.frame = CGRectMake(10.0, top + 200, 160.0, 40.0);
                        
                        //where to put the view
                        top += 240.0;
                        //dispatch_sync(dispatch_get_main_queue(), ^{
                            [self.scrollview addSubview:bubbleView];
                            [self.scrollview addSubview:button];
                        
                            //set the scroll of the view
                            self.scrollview.contentSize = CGSizeMake(320, top);
                        //});
                }
//                [self. reloadData];
                [refreshControl endRefreshing];
            });
        }
    }];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refresh addTarget:self action:@selector(load) forControlEvents:UIControlEventValueChanged];
    
//    self.refreshControl = refresh;
    [self.scrollview addSubview:refresh];
    
    [self load:refresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
