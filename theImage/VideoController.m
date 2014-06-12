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
#import "AppDelegate.h"

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

// extractYoutubeID
- (NSString *)extractYoutubeID:(NSString *)youtubeURL
{
    NSError *error = NULL;
    NSString *regexString = @"(?<=v(=|/))([-a-zA-Z0-9_]+)|(?<=youtu.be/)([-a-zA-Z0-9_]+)";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexString options:NSRegularExpressionCaseInsensitive error:&error];
    NSRange rangeOfFirstMatch = [regex rangeOfFirstMatchInString:youtubeURL options:0 range:NSMakeRange(0, [youtubeURL length])];
    if(!NSEqualRanges(rangeOfFirstMatch, NSMakeRange(NSNotFound, 0)))
    {
        NSString *substringForFirstMatch = [youtubeURL substringWithRange:rangeOfFirstMatch];
        return substringForFirstMatch;
    }
    return nil;
}


-(void) youTubeStarted:(NSNotification*) notif {
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.fullScreenVideoIsPlaying = YES;
}
-(void) youTubeFinished:(NSNotification*) notif {
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.fullScreenVideoIsPlaying = NO;
}

-(BOOL) shouldAutorotate {
    return NO;
}
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

- (void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(youTubeStarted:) name:@"UIMoviePlayerControllerDidEnterFullscreenNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(youTubeFinished:) name:@"UIMoviePlayerControllerWillExitFullscreenNotification" object:nil];
    
    [super viewDidLoad];
    
    top = 0;
    
    //lets us scroll and hold it
    self.scrollview.userInteractionEnabled=YES;
    [self.scrollview setScrollEnabled:YES];
    
    if (self.playerID == PlayerController.meID){
        self.addVideo.hidden = false;
        top = 60;
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://newfootballers.com/get_videos.php/"]];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [request setHTTPBody:[[NSString stringWithFormat:@"userid=%d", self.playerID]dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            
        } else {
            NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                                        options:0
                                                                          error:&error];
            
            UIView *backdrop=[[UIView alloc]initWithFrame:CGRectMake(0, 46, 320, 15000)];
            backdrop.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.8f];
            [self.scrollview addSubview:backdrop];
            
            //set the scroll of the view
            self.scrollview.contentSize = CGSizeMake(320, top);
            
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
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        CGRect webFrame = CGRectMake(00.0, 0.0, 320.0, 180.0);
                        
                        NSString *theURL = [dictionary objectForKey:@"URL"];
                        self.title = [NSString stringWithFormat:@"Videos from %@" ,[dictionary objectForKey:@"Firstname"]];
                        //theURL = [theURL stringByReplacingOccurrencesOfString:@"watch?v=" withString:@"embed/"];

                        theURL = [self extractYoutubeID:theURL];
                        theURL = [NSString stringWithFormat:@"http://www.youtube.com/embed/%@", theURL];
                        
                        //the video
                        NSURL *url = [NSURL URLWithString:theURL];
                        NSURLRequest *req = [NSURLRequest requestWithURL:url];
                        UIWebView *bubbleView = [[UIWebView alloc] initWithFrame:webFrame];
                        bubbleView.backgroundColor = [UIColor blackColor];
                        bubbleView.frame=CGRectMake(0, top, 320, 180);
                        bubbleView.scrollView.scrollEnabled = NO;
                        bubbleView.scrollView.bounces = NO;
                        [bubbleView loadRequest:req];
                        
                        //delete button
                        if (self.playerID == PlayerController.meID){
                            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                            [button addTarget:self action:@selector(deleteVideo:) forControlEvents:UIControlEventTouchUpInside];
                            button.tag = [[dictionary objectForKey:@"VideoID"] intValue];
                            [button setTitle:@"Remove video?" forState:UIControlStateNormal];
                            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

                            button.frame = CGRectMake(-25.0, top + 175, 180.0, 40.0);
                            [self.scrollview addSubview:button];
                            top += 40;
                        }
                        else{
                            top += 20;
                        }
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
                        top += 180;
                        [self.scrollview addSubview:bubbleView];
                        [self.scrollview addSubview:bubbleView];
                        
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
        //theURL = [[theURL stringByReplacingOccurrencesOfString:@"watch?v=" withString:@"embed/"] lowercaseString];
        
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
