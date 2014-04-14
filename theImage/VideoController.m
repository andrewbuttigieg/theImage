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


static float top = 0;
+ (float) top{
    return top;
}

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
    
    //lets us scroll and hold it
    self.scrollview.userInteractionEnabled=YES;
    [self.scrollview setScrollEnabled:YES];
    
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
                else{
                   /* UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"PlayerCV"
                                                                   message: [dictionary objectForKey:@"Comment"]
                                                                  delegate: self
                                                         cancelButtonTitle:@"Ok"
                                                         otherButtonTitles:nil];
                    
                    
                    [alert show];*/
                    dispatch_sync(dispatch_get_main_queue(), ^{

                       /* NSString *newHTML = @"<html>\
                        <style>body{padding:0;margin:0;}</style>\
                        <iframe width=\"300\" height=\"200\" src=\"http://www.youtube.com/embed/zL0CCsdS1cE?autoplay=1\" frameborder=\"0\" allowfullscreen></iframe>\
                        </html>";*/
                        
                        NSString *newHTML = [NSString stringWithFormat:@"<html>\
                                             <style>body{padding:0;margin:0;}</style>\
                                             <iframe width=\"300\" height=\"200\" src=\"%@\" frameborder=\"0\" allowfullscreen></iframe>\
                                             </html>", [dictionary objectForKey:@"URL"]];
                        //http://www.youtube.com/embed/zL0CCsdS1cE?autoplay=1
                        
                        //[self.webView loadHTMLString:newHTML baseURL:nil];
                        
                        CGRect webFrame = CGRectMake(10.0, 0.0, 300.0, 200.0);
                        UIWebView *bubbleView = [[UIWebView alloc] initWithFrame:webFrame];
                        bubbleView.backgroundColor = [UIColor blackColor];
                        bubbleView.frame=CGRectMake(10, top, 300, 200);
                        [bubbleView loadHTMLString:newHTML baseURL:nil];
                        
                        //where to put the text
                        top += 220;
                        [self.scrollview addSubview:bubbleView];
                        
                        //set the scroll of the view
                        self.scrollview.contentSize = CGSizeMake(320, top);
                    });
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
