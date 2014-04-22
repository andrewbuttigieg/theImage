//
//  NearYouController.m
//  theImage
//
//  Created by Andrew Buttigieg on 4/21/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import "NearYouController.h"
#import "PlayerController.h"
#import "nearYouCell.h"
#import <CoreLocation/CoreLocation.h>

@interface NearYouController ()

@end

@implementation NearYouController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.userIDForNear count];
}

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath {
    
    int idx=indexPath.row;
    
    NSString *o = [self.userIDForNear objectAtIndex:idx];
    
    /////////
    NSString * storyboardName = @"Main_iPhone";
    NSString * viewControllerID = @"PlayerController";
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    PlayerController * controller = (PlayerController *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
    controller.playerID = [o integerValue];
    [self.navigationController pushViewController:controller animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"nearYouCell";
    
    nearYouCell * cell = [tableView
                        dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[nearYouCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.name.text = [self.nameForNear
                      objectAtIndex: [indexPath row]];
    cell.distance.text = [self.locationForNear
                         objectAtIndex: [indexPath row]];
    
    
    cell.personImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self.imageForNear objectAtIndex: [indexPath row]]]]];
    
    cell.personImage.layer.cornerRadius = 28.0;
    cell.personImage.layer.masksToBounds = YES;
    cell.personImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.personImage.layer.borderWidth = 0.3;
    
    NSString *type = [self.userTypeForNear objectAtIndex: [indexPath row]];
    if ([type isEqual: @"1"])
    {
        type = @"Player";
    }
    else if ([type isEqual: @"2"])
    {
        type = @"Scout";
    }
    else if ([type isEqual: @"3"])
    {
        type = @"Agent";
    }
    /*
     else if ([type isEqual: @"4"])
     {
     type = @"";
     }*/
    cell.type.text = type;

    
    return cell;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    self.nameForNear  = [[NSMutableArray alloc]
                       initWithObjects:nil];
    
    self.imageForNear =[[NSMutableArray alloc]
                      initWithObjects:nil];
    
    self.userIDForNear =[[NSMutableArray alloc]
                       initWithObjects:nil];
    
    self.userTypeForNear =[[NSMutableArray alloc]
                         initWithObjects:nil];
    
    self.locationForNear =[[NSMutableArray alloc]
                         initWithObjects:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://newfootballers.com/get_near_me.php"]];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [request setHTTPMethod:@"POST"];
    
    self.title = @"Near You";
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            //[self.delegate fetchingGroupsFailedWithError:error];
        } else {
            //[self.delegate receivedGroupsJSON:data];
            NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                                        options:0
                                                                          error:&error];
            dispatch_async(dispatch_get_main_queue(), ^{

                                    NSLog(@"%@", jsonArray);
                for(NSDictionary *dictionary in jsonArray)
                {

                    NSDictionary *theUserD = [dictionary valueForKey:@"User"];
                    for (id key in theUserD)
                    {
                        NSDictionary *anObject;
                        
                        anObject = [theUserD objectForKey:key];
                    
                        [self.nameForNear addObject:[anObject objectForKey:@"Firstname"]];
                        [self.imageForNear addObject:[anObject objectForKey:@"PhotoURL"]];
                        //[self.textForNear addObject:[dictionary objectForKey:@"Text"]];
                        [self.userTypeForNear addObject:[anObject objectForKey:@"UserType"]];
                        [self.userIDForNear addObject:[anObject objectForKey:@"UserID"]];
                        
                        float long1 = [[anObject objectForKey:@"long1"] floatValue];
                        float long2 = [[anObject objectForKey:@"long2"] floatValue];
                        float lat1 = [[anObject objectForKey:@"lat1"] floatValue];
                        float lat2 = [[anObject objectForKey:@"lat2"] floatValue];
                        
                        CLLocation *location1 = [[CLLocation alloc] initWithLatitude:lat1 longitude:long1];
                        CLLocation *location2 = [[CLLocation alloc] initWithLatitude:lat2 longitude:long2];
                        
                        //if (![dictionary objectForKey:@"Country"] || [[dictionary objectForKey:@"Country" ] isKindOfClass:[NSNull class]]){
                            [self.locationForNear addObject:[NSString stringWithFormat:@"%d metres away",
                                                             (int)[location1 distanceFromLocation:location2]]];
                        //}
                        //else
                        //    [self.locationForNear addObject:[dictionary objectForKey:@"Country"]];
                    }
                }
                [self.tableView reloadData];
//                [self performSelector:@selector(stopRefresh) withObject:nil afterDelay:2.5];
            });
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
