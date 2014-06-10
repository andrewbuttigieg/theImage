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

@interface FindPlayerController ()

@end

@implementation FindPlayerController

UIActivityIndicatorView *spinner;

- (IBAction)reloadExplore:(id)sender {
    [self findPeople:findPlayerID];
}

- (IBAction)findCoach:(id)sender {
    self.agent.tintColor = [UIColor blackColor];
    self.player.tintColor = [UIColor blackColor];
    self.scout.tintColor = [UIColor blackColor];
    self.coach.tintColor = [UIColor colorWithRed:0.0f green:0.674f blue:0.933f alpha:1];
    findPlayerID = 4;
    [self findPeople:findPlayerID];
}

static int findPlayerID = 0;

- (IBAction)findThePlayer:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    NSLog(@"@%", [segmentedControl titleForSegmentAtIndex: [segmentedControl selectedSegmentIndex]]);
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

- (void)findPeople:(NSInteger) type{
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = CGPointMake(160, 200);
    spinner.hidesWhenStopped = YES;
    spinner.tag = 12121212;
    [self.view addSubview:spinner];
    [spinner startAnimating];
    
    [[self.putThemThere subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.putThemThere addSubview:spinner];    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://newfootballers.com/get_users.php"]];
    
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [request setHTTPBody:[[NSString stringWithFormat:@"&u=%d", (int)type]dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    //dont get me
    
    
    //    NSURL *url = [[NSURL alloc] initWithString:urlAsString];
    //NSLog(@"%@", urlAsString);
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            //[self.delegate fetchingGroupsFailedWithError:error];
        } else {
/*            NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
            NSMutableArray *groups = [[NSMutableArray alloc] init];*/
            NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                                        options:0
                                                                          error:&error];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSInteger col = 0;
                NSInteger row = 0;
                NSInteger total = 0;
                
                for(NSDictionary *dictionary in jsonArray)
                {
                    NSString *imageURL = [dictionary objectForKey:@"PhotoURL"];
                    UIImage *image;
                    
                    if ([imageURL length] > 5){
                        image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
                    }
                    else{
                        //default image
                        image = [UIImage imageNamed:@"player.png"];
                    }
                    UIImageView *iv = [[UIImageView alloc] initWithImage:image];
                    iv.clipsToBounds = YES;
                    iv.contentMode = UIViewContentModeScaleAspectFill;
                    //CGRect frame;
                    iv.frame=CGRectMake(col * 106 + 1, row * 106, 104,104);
                    iv.tag = [[dictionary objectForKey:@"UserID"] intValue];
                    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
                    [iv addGestureRecognizer:singleTap];
                    [iv setMultipleTouchEnabled:YES];
                    [iv setUserInteractionEnabled:YES];
                    
                    if (col > 1){
                        col = 0;
                        row++;
                    }
                    else{
                        col++;
                    }
                    
                    total++;
                    [self.putThemThere addSubview:iv];
                }
                
                self.putThemThere.contentSize = CGSizeMake(320, (row + 1) * 106);
                [self.putThemThere setContentSize:(CGSizeMake(320, (row + 1) * 106))];
                [spinner stopAnimating];
            });
            self.putThemThere.userInteractionEnabled=YES;
            [self.putThemThere setScrollEnabled:YES];
        }
    }];
}

- (IBAction)findScout:(id)sender {
    self.agent.tintColor = [UIColor blackColor];
    self.player.tintColor = [UIColor blackColor];
    self.scout.tintColor = [UIColor colorWithRed:0.0f green:0.674f blue:0.933f alpha:1];
    self.coach.tintColor = [UIColor blackColor];
    findPlayerID = 2;
    [self findPeople:findPlayerID];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.agent.tintColor = [UIColor blackColor];
    self.player.tintColor = [UIColor colorWithRed:0.0f green:0.674f blue:0.933f alpha:1];
    self.scout.tintColor = [UIColor blackColor];
    self.coach.tintColor = [UIColor blackColor];
    self.title = @"Explore";
    findPlayerID = 1; //player...
    [self findPeople:findPlayerID];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)findPlayer:(id)sender {
    self.agent.tintColor = [UIColor colorWithRed:0.0f green:0.674f blue:0.933f alpha:1];
    self.player.tintColor = [UIColor blackColor];
    self.scout.tintColor = [UIColor blackColor];
    self.coach.tintColor = [UIColor blackColor];
    findPlayerID = 1;
    [self findPeople:findPlayerID];
}
- (IBAction)findAgent:(id)sender {
    self.agent.tintColor = [UIColor colorWithRed:0.0f green:0.674f blue:0.933f alpha:1];
    self.player.tintColor = [UIColor blackColor];
    self.scout.tintColor = [UIColor blackColor];
    self.coach.tintColor = [UIColor blackColor];
    findPlayerID = 3;
    [self findPeople:findPlayerID];
}
@end
