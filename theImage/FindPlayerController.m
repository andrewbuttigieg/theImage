//
//  FindPlayerController.m
//  theImage
//
//  Created by Andrew Buttigieg on 1/8/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import "FindPlayerController.h"
#import "PlayerController.h"
#import "PlayerController.h"
#import "UIImageView+AFNetworking.h"
#import "ValidURL.h"

@interface FindPlayerController ()

@end

@implementation FindPlayerController

UIActivityIndicatorView *spinner;

- (IBAction)reloadExplore:(id)sender {
    [self findPeople:findPlayerID :@""];
}

- (IBAction)findCoach:(id)sender {
    self.agent.tintColor = [UIColor blackColor];
    self.player.tintColor = [UIColor blackColor];
    self.scout.tintColor = [UIColor blackColor];
    self.coach.tintColor = [UIColor colorWithRed:0.0f green:0.674f blue:0.933f alpha:1];
    findPlayerID = 4;
    [self findPeople:findPlayerID : @""];
}

static int findPlayerID = 0;

- (IBAction)findThePlayer:(id)sender {
    /*UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    NSLog(@"@%", [segmentedControl titleForSegmentAtIndex: [segmentedControl selectedSegmentIndex]]);*/
}

+ (int) findPlayerID{
    return findPlayerID;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = NO;
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.toolbarHidden = YES;
}

/*
 show the person details. let you friend them etc
 */
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

- (void)findPeople:(NSInteger) type :(NSString*)name{
    
    [self.putThemThere setContentOffset:CGPointMake(0.0, -60.0) animated:NO];
    
    
    for (UIView *view in self.putThemThere.subviews)
    {
        if ([view isKindOfClass:[UIImageView class]] || ( [view isKindOfClass:[UIView class]] && ![view isKindOfClass:[UITextField class]] && view.tag != -69)){
            [view removeFromSuperview];
        }
    }
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = CGPointMake(160, 200);
    spinner.hidesWhenStopped = YES;
    spinner.tag = 12121212;
    [self.view addSubview:spinner];
    [spinner startAnimating];
    
   /* [[self.putThemThere subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];*/
    [self.putThemThere addSubview:spinner];
    
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://newfootballers.com/get_users.php"]];
    
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [request setHTTPBody:[[NSString stringWithFormat:@"&u=%d&q=%@", (int)type, name]dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    //dont get me
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            //[self.delegate fetchingGroupsFailedWithError:error];
        } else {
            
            if (findPlayerID == type) {
                
            
                NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                                            options:0
                                                                              error:&error];
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSInteger col = -1;
                    NSInteger row = 0;
                    NSInteger total = 0;
                    
                    for(NSDictionary *dictionary in jsonArray)
                    {
                        if (col > 0){
                            col = 0;
                            row++;
                        }
                        else{
                            col++;
                        }
                        
                        
                        NSString *imageURL = [dictionary objectForKey:@"PhotoURL"];
                        UIImage *image;
                        
                        
                        //default image
                        image = [UIImage imageNamed:@"player.png"];
                        UIImageView *iv = [[UIImageView alloc] initWithImage:image];
                    
                        if ([ValidURL isValidUrl :imageURL]){
                            
                          //  NSMutableURLRequest * request = [[NSMutableURLRequest  alloc] initWithURL:[NSURL URLWithString:imageURL]];
                        /*    request.cachePolicy = NSURLRequestReloadIgnoringCacheData;
                            [iv setImageWithURLRequest:request
                                             placeholderImage:[UIImage imageNamed:@"player.png"]
                                                      success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                          dispatch_async(dispatch_get_main_queue(), ^{
                                                              iv.image = image;
                                                          });
                                                          
                                                      } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                          NSLog(@"failed loading image: %@", error);
                                                      }];*/
                            [iv setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"player.png"]];

                            
//                            [iv setImageWithURL:[NSURL URLWithString:imageURL]];
                            
                            //[iv setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"player.png"]];
                        }
                    
                        iv.clipsToBounds = YES;
                        iv.contentMode = UIViewContentModeScaleAspectFill;
                        //CGRect frame;
                        iv.frame=CGRectMake(col * 157 + 5, (row * (157 + 35)) + 45, 152, 152);
                        iv.tag = [[dictionary objectForKey:@"UserID"] intValue];
                        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
                        [iv addGestureRecognizer:singleTap];
                        [iv setMultipleTouchEnabled:YES];
                        [iv setUserInteractionEnabled:YES];
                        
                        total++;
                        [self.putThemThere addSubview:iv];
                        
                        //UIFont * customFont = [UIFont fontWithName:ProximaNovaSemibold size:12]; //custom font
                        NSString * text;
                        
                        if ([dictionary objectForKey:@"Age"] != [NSNull null])
                            text = [NSString stringWithFormat:@"%@ %@, %@", [dictionary objectForKey:@"Firstname"], [dictionary objectForKey:@"Lastname"]
                                           , [dictionary objectForKey:@"Age"] ];
                        else
                            text = [NSString stringWithFormat:@"%@ %@", [dictionary objectForKey:@"Firstname"], [dictionary objectForKey:@"Lastname"]];
                        
                        UIView *bubbleView = [[UIView alloc] initWithFrame:CGRectMake(col * 157 + 5, ((row) * (157 + 35)) + 35 + 157, 152, 35)];
                        bubbleView.backgroundColor = [UIColor blackColor];
                        //
                        UILabel *fromLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, -5, 150, 30)];
                        fromLabel.text = text;
                        //fromLabel.font = customFont;
                        fromLabel.numberOfLines = 1;
                        fromLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
                        fromLabel.adjustsFontSizeToFitWidth = YES;
                        //fromLabel.adjustsLetterSpacingToFitWidth = YES;
                        fromLabel.minimumScaleFactor = 10.0f/12.0f;                        
                        fromLabel.font=[fromLabel.font fontWithSize:10];
                        [fromLabel setFont:[UIFont boldSystemFontOfSize:12]];
                        fromLabel.clipsToBounds = YES;
                        fromLabel.backgroundColor = [UIColor clearColor];
                        fromLabel.textColor = [UIColor whiteColor];
                        fromLabel.textAlignment = NSTextAlignmentLeft;
                        
                        
                        
                        
                        text = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"Position"]];
                        
                        NSRange rangeOfYourString = [text rangeOfString:@"("];
                        if(rangeOfYourString.location != NSNotFound)
                        {
                            text = [text substringToIndex:rangeOfYourString.location];
                        }
                        
                        UILabel *positionLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 14, 150, 20)];
                        positionLabel.text = text;
                        //fromLabel.font = customFont;
                        positionLabel.numberOfLines = 1;
                        positionLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
                        positionLabel.adjustsFontSizeToFitWidth = YES;
                        //fromLabel.adjustsLetterSpacingToFitWidth = YES;
                        positionLabel.minimumScaleFactor = 10.0f/12.0f;
                        positionLabel.font=[positionLabel.font fontWithSize:10];
                        positionLabel.clipsToBounds = YES;
                        positionLabel.backgroundColor = [UIColor clearColor];
                        positionLabel.textColor = [UIColor whiteColor];
                        positionLabel.textAlignment = NSTextAlignmentLeft;
                        
                        [bubbleView addSubview:fromLabel];
                        [bubbleView addSubview:positionLabel];

                        [self.putThemThere addSubview:bubbleView];
                    }
                    
                    self.putThemThere.contentSize = CGSizeMake(320, ((row + 1) * (157 + 35)) + 5 + 35);
                    [self.putThemThere setContentSize:(CGSizeMake(320, ((row + 1) * (157 + 35)) + 5 + 35))];
                    [spinner stopAnimating];
                
                });
                self.putThemThere.userInteractionEnabled=YES;
                [self.putThemThere setScrollEnabled:YES];
            }
        }
    }];
}

- (IBAction)findScout:(id)sender {
    self.agent.tintColor = [UIColor blackColor];
    self.player.tintColor = [UIColor blackColor];
    self.scout.tintColor = [UIColor colorWithRed:0.0f green:0.674f blue:0.933f alpha:1];
    self.coach.tintColor = [UIColor blackColor];
    findPlayerID = 2;
    [self findPeople:findPlayerID:@""];
}

- (BOOL)textFieldShouldReturn:(UITextField *)aTextfield {
    [aTextfield resignFirstResponder];
    [self findPeople:findPlayerID:self.finder.text];
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.finder.returnKeyType=UIReturnKeyDone;
    self.finder.delegate = self;
    self.putThemThere.scrollsToTop = YES;
        
    self.agent.tintColor = [UIColor blackColor];
    self.player.tintColor = [UIColor colorWithRed:0.0f green:0.674f blue:0.933f alpha:1];
    self.scout.tintColor = [UIColor blackColor];
    self.coach.tintColor = [UIColor blackColor];
    self.title = @"Explore";
    findPlayerID = 1; //player...
    [self findPeople:findPlayerID:@""];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)findPlayer:(id)sender {
    self.agent.tintColor = [UIColor blackColor];
    self.player.tintColor = [UIColor colorWithRed:0.0f green:0.674f blue:0.933f alpha:1];
    self.scout.tintColor = [UIColor blackColor];
    self.coach.tintColor = [UIColor blackColor];
    findPlayerID = 1;
    [self findPeople:findPlayerID:@""];
}
- (IBAction)findAgent:(id)sender {
    self.agent.tintColor = [UIColor colorWithRed:0.0f green:0.674f blue:0.933f alpha:1];
    self.player.tintColor = [UIColor blackColor];
    self.scout.tintColor = [UIColor blackColor];
    self.coach.tintColor = [UIColor blackColor];
    findPlayerID = 3;
    [self findPeople:findPlayerID:@""];
}
@end
