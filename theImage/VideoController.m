//
//  VideoController.m
//  theImage
//
//  Created by Andrew Buttigieg on 4/12/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import "VideoController.h"
#import "PlayerController.h"
#import "ImageEffect.h"

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

- (void)deleteVideo:(id)sender{
    UIButton *button = (UIButton *)sender;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://newfootballers.com/delete_video.php/"]];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [request setHTTPBody:[[NSString stringWithFormat:@"videoid=%d", (int)button.tag]dataUsingEncoding:NSUTF8StringEncoding]];
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
                   });
               }
               
           }
       }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    top = 0;
    
    //lets us scroll and hold it
    self.scrollview.userInteractionEnabled=YES;
    [self.scrollview setScrollEnabled:YES];
    
    if (self.playerID == PlayerController.meID){
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
                        [button setTitle:@"Remove video?" forState:UIControlStateNormal];
                        button.frame = CGRectMake(2.0, top + 190, 160.0, 40.0);
                        
                        //get the player image
                        NSString *imageURL = [dictionary objectForKey:@"PhotoURL"];
                        UIImage * image;
                        if ([imageURL length] > 5){
                            image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
                            
                        }
                        else{
                            //default image
                            image = [UIImage imageNamed:@"player.png"];
                        }
                        
                        self.scrollview.backgroundColor = [UIColor colorWithPatternImage:[ImageEffect blur:image]];
                        
                        //where to put the view
                        top += 240;
                        [self.scrollview addSubview:bubbleView];
                        [self.scrollview addSubview:button];
                        
                        //set the scroll of the view
                        self.scrollview.contentSize = CGSizeMake(320, top);
                    });
                }
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
        NSString *theURL = self.addVideoLink.text;
        theURL = [[theURL stringByReplacingOccurrencesOfString:@"watch?v=" withString:@"embed/"] lowercaseString];
        
        if ([[theURL lowercaseString] rangeOfString:@"vimeo"].location != NSNotFound){
            //vimeo video
            NSURL* url=[NSURL URLWithString:theURL];
            NSString* last=[url lastPathComponent];
            theURL = [NSString stringWithFormat:@"http://player.vimeo.com/video/%@", last];
        }
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://newfootballers.com/add_video.php/"]];
        [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
        [request setHTTPBody:[[NSString stringWithFormat:@"url=%@&comment=%@", theURL, @"-"]dataUsingEncoding:NSUTF8StringEncoding]];
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

                    dispatch_async(dispatch_get_main_queue(), ^{
                        //if ([self.playerInteract.title isEqualToString:@"Connect"]){
                        if ([[dictionary objectForKey:@"accepted"] intValue] == 1){
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"PlayerCV"
                                                                   message: @"Video added"
                                                                  delegate: self
                                                         cancelButtonTitle:@"OK"
                                                         otherButtonTitles:nil];
                    
                    
                            [alert show];
                        }
                        else{
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"PlayerCV"
                                                                           message: [dictionary objectForKey:@"value"]
                                                                          delegate: self
                                                                 cancelButtonTitle:@"OK"
                                                                 otherButtonTitles:nil];
                            
                            
                            [alert show];
                        }
                    });
                }
            }
        }];
    }
    else{
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"PlayerCV"
                                                        message:[NSString stringWithFormat:@"%@",@"That is not a valid link"]
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
            [alert show];
        });
    }
}
@end
