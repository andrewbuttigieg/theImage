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
static UIRefreshControl *refreshControl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)isValidUrl:(NSString *)urlString{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    return [NSURLConnection canHandleRequest:request];
}

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    UIView *tappedView = [gesture.view hitTest:[gesture locationInView:gesture.view] withEvent:nil];
    //    NSLog(@"Touch event on view: %@",[tappedView class]);
    //    NSLog([NSString stringWithFormat:@"%d", tappedView.tag]);
    
    
    /////////
    NSString * storyboardName = @"Main_iPhone";
    NSString * viewControllerID = @"PlayerController";
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    PlayerController * controller = (PlayerController *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
    controller.playerID = tappedView.tag;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)load{
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
                    

                    NSString *imageURL = [dictionary objectForKey:@"PhotoURL"];
                    imageURL = [imageURL stringByReplacingOccurrencesOfString:@".com/"
                                                                   withString:@".com/[120]-"];
                    UIImage *image;
                    if ([self isValidUrl : imageURL] ){
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
                    iv.frame=CGRectMake(10, top + 10, 60,60);
                    iv.tag = [[dictionary objectForKey:@"UserID"] intValue];
                    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
                    [iv addGestureRecognizer:singleTap];
                    [iv setMultipleTouchEnabled:YES];
                    [iv setUserInteractionEnabled:YES];

                    
                    top += 80.0;
                    //dispatch_sync(dispatch_get_main_queue(), ^{
                    [self.scrollview addSubview:iv];
                    
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
                        bubbleView.scrollView.scrollEnabled = NO;
                        bubbleView.scrollView.bounces = NO;
                        bubbleView.backgroundColor = [UIColor blackColor];
                        bubbleView.frame=CGRectMake(0, top, 320, 200);
                        [bubbleView loadRequest:req];
                        //delete button
                    
                        /*UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                        [button addTarget:self action:@selector(deleteVideo:) forControlEvents:UIControlEventTouchUpInside];
                        button.tag = [[dictionary objectForKey:@"VideoID"] intValue];
                        [button setTitle:@"Delete" forState:UIControlStateNormal];
                        button.frame = CGRectMake(10.0, top + 200, 160.0, 40.0);*/
                        
                        //where to put the view
                        top += 200.0;
                        //dispatch_sync(dispatch_get_main_queue(), ^{
                            [self.scrollview addSubview:bubbleView];
                        //[self.scrollview addSubview:button];
                        
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
    refreshControl = [[UIRefreshControl alloc] init];
    
    self.title = @"Videos";
    
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refreshControl addTarget:self action:@selector(load) forControlEvents:UIControlEventValueChanged];
    [self.scrollview addSubview:refreshControl];
    
    [self load];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
