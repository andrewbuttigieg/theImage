//
//  FindPlayerController.m
//  theImage
//
//  Created by Andrew Buttigieg on 1/8/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import "FindPlayerController.h"
#import "PlayerController.h"
#import "Group.h"

@interface FindPlayerController ()

@end

@implementation FindPlayerController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    UIView *tappedView = [gesture.view hitTest:[gesture locationInView:gesture.view] withEvent:nil];
    NSLog(@"Touch event on view: %@",[tappedView class]);
    NSLog([NSString stringWithFormat:@"%d", tappedView.tag]);
    
    
    /////////
    NSString * storyboardName = @"Main_iPhone";
    NSString * viewControllerID = @"PlayerController";
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    PlayerController * controller = (PlayerController *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
    controller.playerID = tappedView.tag;
    /*
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    UIBarButtonItem *temporaryBarButtonItem = [UIBarButtonItem new];
    [temporaryBarButtonItem setTitle:@"Back"];
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    [self presentViewController:navigationController animated:YES completion:nil];
     */
    [self.navigationController pushViewController:controller animated:YES];
    
/*    PlayerController *viewController = [[PlayerController alloc] init];
    [self presentViewController:viewController animated:YES completion:nil];*/
    ///////
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    //[[self navigationController] setNavigationBarHidden:NO animated:YES];

//    NSString *urlAsString = [NSString stringWithFormat:@"http://newfootballers.com/get_users.php"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://newfootballers.com/get_users.php"]];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [request setHTTPBody:[[NSString stringWithFormat:@"me=%d", 1]dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    //dont get me
    
    
//    NSURL *url = [[NSURL alloc] initWithString:urlAsString];
    //NSLog(@"%@", urlAsString);
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            //[self.delegate fetchingGroupsFailedWithError:error];
        } else {
            //[self.delegate receivedGroupsJSON:data];
            NSError *localError = nil;
            NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
            
            NSMutableArray *groups = [[NSMutableArray alloc] init];
            
            
            
            
            NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                        options:0
                                                          error:&error];
            
            dispatch_async(dispatch_get_main_queue(), ^{
            NSInteger col = 0;
            NSInteger row = 0;
            
            for(NSDictionary *dictionary in jsonArray)
            {
                NSLog(@"Data Dictionary is : %@",dictionary);
                NSString *imageURL = [dictionary objectForKey:@"PhotoURL"];
                NSLog(@"%@", imageURL);
                
                
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
                UIImageView *iv = [[UIImageView alloc] initWithImage:image];
                        //CGRect frame;
                iv.frame=CGRectMake(col * 106, row * 106, 106,106);
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
                
                    [self.putThemThere addSubview:iv];
                
            }
            
                self.putThemThere.contentSize = CGSizeMake(320, row * 106);
                [self.putThemThere setContentSize:(CGSizeMake(320, row * 106))];
            });
            self.putThemThere.userInteractionEnabled=YES;
            [self.putThemThere setScrollEnabled:YES];
            
            //for (NSDictionary *groupDic in results) {
              /*  Group *group = [[Group alloc] init];
                
                NSString *posts = [parsedObject valueForKey:@"Firstname"];
                *//*for (NSString *key in groupDic) {
                    if ([group respondsToSelector:NSSelectorFromString(key)]) {
                        [group setValue:[groupDic valueForKey:key] forKey:key];
                    }
                }*/
            
                //NSLog(@"Count %s", posts);
                //[groups addObject:group];
            //}
        }
    }];
    
    /*
    for(int j=0; j< 20; ++j)
    {
        for(int i=0; i< 3; i++)
        {
            UIImageView*   iv =[[UIImageView alloc] initWithImage:[UIImage  imageNamed:@"player.png"]];
            //CGRect frame;
            iv.frame=CGRectMake(i * 106, j * 106, 106,106);
            iv.tag = i;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
            [iv addGestureRecognizer:singleTap];
            [iv setMultipleTouchEnabled:YES];
            [iv setUserInteractionEnabled:YES];
            
            
            [self.putThemThere addSubview:iv];
        }
    }
    self.putThemThere.contentSize = CGSizeMake(320, 20 * 106);
    
    [self.putThemThere setContentSize:(CGSizeMake(320, 20 * 106))];
    
    self.putThemThere.userInteractionEnabled=YES;
    [self.putThemThere setScrollEnabled:YES];*/
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
