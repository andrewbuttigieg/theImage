//
//  AllVideoController.m
//  theImage
//
//  Created by Andrew Buttigieg on 4/24/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import "AllVideoController.h"
#import "PlayerController.h"
#import "ImageEffect.h"
#import "AppDelegate.h"

@interface AllVideoController ()

@end

@implementation AllVideoController


static float top = 0;
static float current = 0;
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
//    CGFloat y = -scrollView.contentOffset.y;
 //   CGPointMake(self.view.center.x, self.view.center.y);
    int i = 0;
    int j = -1;
    for (i = 1; i < self.scrollview.subviews.count; i++){
        UIScrollView * temp = (UIScrollView *)self.scrollview.subviews[i];
        if (temp.subviews.count >= 2){
            UIImageView * iv = (UIImageView *)temp.subviews[0];
            int y = scrollView.contentOffset.y - (j++ * (180 + 80)) + 64;
            if (y > 0 && y < (320 - 80)){
                iv.frame = CGRectMake(0, 0 - y, 320, 320);
            }
        }
    }
}

// extractYoutubeID
- (NSString *)extractYoutubeID:(NSString *)youtubeURL
{
    //NSLog(@"youtube  %@",youtubeURL);
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

-(void)doWorkContainer:(id)sender{
    if (current < self.position.count){
        [self doWork];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"PlayerCV"
                                                        message:@"No more videos."
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void)doWork{
    
    top = 0;
    for (UIView* view in self.scrollview.subviews)
    {
        if ([view isKindOfClass:[UIScrollView class]]
                || [view isKindOfClass:[UIWebView class]]
                || [view isKindOfClass:[UIButton class]])
        {
            [view removeFromSuperview];
        }
    }
    for (int i = current; i < current + 10 && i < self.position.count; i++){
        
        NSString *imageURL = self.image[i]; // [dictionary objectForKey:@"PhotoURL"];
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
        iv.frame=CGRectMake(10, 10, 60,60);
        iv.tag = [self.userID[i] intValue];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
        [iv addGestureRecognizer:singleTap];
        [iv setMultipleTouchEnabled:YES];
        [iv setUserInteractionEnabled:YES];
        
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(90, 10, 60, 30)];
        lb.textColor = [UIColor colorWithRed:(1.0f) green:(1.0f) blue:(1.0f) alpha:1];
        
        [lb setFont:[UIFont systemFontOfSize:17]];
        lb.text = self.name[i];
        [lb sizeToFit];
        lb.textAlignment = NSTextAlignmentLeft;
        
        
        UIImageView *iv2 = [[UIImageView alloc] initWithImage:[ImageEffect blur:image]];
        iv2.frame=CGRectMake(0, 0, 320, 320);
        UIScrollView *secondScroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0, top, 320, 80)];
        
        UIView *backdrop=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 320)];
        backdrop.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.8f];
        
        [secondScroll addSubview:iv2];
        [secondScroll addSubview:backdrop];
        [secondScroll addSubview:lb];
        
        /////
        lb = [[UILabel alloc] initWithFrame:CGRectMake(90, 30, 60, 30)];
        lb.textColor = [UIColor colorWithRed:(1.0f) green:(1.0f) blue:(1.0f) alpha:1];
        [lb setFont:[UIFont systemFontOfSize:13]];
        
        if (self.position[i] != [NSNull null] &&
            self.position[i] != nil &&
            [self.position[i] length] > 0 &&
            ![self.position[i] isEqualToString:@"0"]){
            lb.text = self.position[i];
        }
        [lb sizeToFit];
        lb.textAlignment = NSTextAlignmentLeft;
        [secondScroll addSubview:lb];
        /////
        lb = [[UILabel alloc] initWithFrame:CGRectMake(90, 53, 60, 30)];
        lb.textColor = [UIColor colorWithRed:(1.0f) green:(1.0f) blue:(1.0f) alpha:1];
        [lb setFont:[UIFont systemFontOfSize:13]];
        lb.text = self.country[i];
        [lb sizeToFit];
        lb.textAlignment = NSTextAlignmentLeft;
        [secondScroll addSubview:lb];
        /////
        
        [secondScroll addSubview:iv];
        top += 80.0;
        //dispatch_sync(dispatch_get_main_queue(), ^{
        [self.scrollview addSubview:secondScroll];
        
        CGRect webFrame = CGRectMake(00.0, 0.0, 320.0, 180);
        NSString *theURL = self.link[i];
        theURL = [self extractYoutubeID:theURL];
        theURL = [NSString stringWithFormat:@"http://www.youtube.com/embed/%@", theURL];
        
        //the video
        NSURL *url = [NSURL URLWithString:theURL];
        NSURLRequest *req = [NSURLRequest requestWithURL:url];
        UIWebView *bubbleView = [[UIWebView alloc] initWithFrame:webFrame];
        bubbleView.scrollView.scrollEnabled = NO;
        bubbleView.scrollView.bounces = NO;
        bubbleView.backgroundColor = [UIColor blackColor];
        bubbleView.frame=CGRectMake(0, top, 320, 180);
        [bubbleView loadRequest:req];
        
        //where to put the view
        top += 180.0;
        [self.scrollview addSubview:bubbleView];
    }
    
    current += 10;

    if (current < self.position.count){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button addTarget:self action:@selector(doWorkContainer:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"More" forState:UIControlStateNormal];
        button.frame = CGRectMake(70, top + 10, 180.0, 40.0);
        button.titleLabel.textColor = [UIColor whiteColor];
        [button setTitleColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
        
        button.backgroundColor = [UIColor colorWithRed:(0.0f/255.0f) green:(173.0f/255.0f) blue:(239.0f/255.0f) alpha:1];
        button.layer.cornerRadius = 3.0;
        [self.scrollview addSubview:button];
    }
    
    //set the scroll of the view
    self.scrollview.contentSize = CGSizeMake(320, top + 60);
    
}

-(void)load{
    
    self.link = [[NSMutableArray alloc] initWithObjects:nil];
    self.name = [[NSMutableArray alloc] initWithObjects:nil];
    self.image  = [[NSMutableArray alloc] initWithObjects:nil];
    self.country = [[NSMutableArray alloc] initWithObjects:nil];
    self.position = [[NSMutableArray alloc] initWithObjects:nil];
    self.userID = [[NSMutableArray alloc] initWithObjects:nil];
    
    
    top = 0.0;
    current = 0;
    self.scrollview.delegate = self;
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://newfootballers.com/get_all_videos.php/"]];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
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
                    
                    [self.image addObject:[dictionary objectForKey:@"PhotoURL"]];
                    [self.userID addObject:[dictionary objectForKey:@"UserID"]];
                    [self.name addObject:[NSString stringWithFormat:@"%@ %@",
                                           [dictionary objectForKey:@"Firstname"],
                                           [dictionary objectForKey:@"Lastname"]]];
                    [self.country addObject:[dictionary objectForKey:@"Country"]];
                    [self.position addObject:[dictionary objectForKey:@"Position"]];
                    [self.link addObject:[dictionary objectForKey:@"URL"]];
                    
                }
                [self doWork];
                [refreshControl endRefreshing];
            });
        }
    }];
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
	// Do any additional setup after loading the view.
    refreshControl = [[UIRefreshControl alloc] init];
    
    self.title = @"Videos";
    
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Discover and be discovered"];
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
