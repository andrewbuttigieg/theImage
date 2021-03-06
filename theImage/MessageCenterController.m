//
//  MessageCenterController.m
//  theImage
//
//  Created by Andrew Buttigieg on 2/10/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import "MessageCenterController.h"
#import "messageGroupCell.h"
#import "MessageViewController.h"
#import "ValidURL.h"
#import "UIViewController+AMSlideMenu.h"
#import "AMSlideMenuMainViewController.h"
#import "UIImageView+AFNetworking.h"

@interface MessageCenterController () <MessageCenterChangeDelegate>

@end

@implementation MessageCenterController



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    return [self.dateForTable count];
}

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath {
    
    int idx = (int)indexPath.row;
    NSString *o = [self.userIDForTable objectAtIndex:idx];
   /* NSString *name = [self.nameForTable objectAtIndex:idx];
    NSString *image = [self.imageForTable objectAtIndex:idx];*/
    self.textForTable = self.textForTable;
    
    
    /////////
    NSString * storyboardName = @"Main_iPhone";
    NSString * viewControllerID = @"MessageViewController";
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    MessageViewController * controller = (MessageViewController *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
    controller.chattingToID = [o intValue];
    controller.tagToUpdate = idx;
    
    controller.delegate = self;

    /*    controller.name = name;
    controller.image = image;*/
 
    [self.navigationController pushViewController:controller animated:YES];
}

/*
 This sets the value of the items in the cell
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"messageGroupCell";
    
    messageGroupCell *cell = [tableView
                              dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[messageGroupCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.name.text = [self.nameForTable
                      objectAtIndex: [indexPath row]];
    cell.date.text = [self.dateForTable
                      objectAtIndex: [indexPath row]];

    if ([ValidURL isValidUrl : [self.imageForTable objectAtIndex: [indexPath row]]]){
        
        NSString *imageURL = [self.imageForTable objectAtIndex: [indexPath row]];
        imageURL = [imageURL stringByReplacingOccurrencesOfString:@".com/"
                                                       withString:@".com/[120]-"];
        
        [cell.personImage setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"player.png"]];
    }
    else
        cell.personImage.image = [UIImage imageNamed:@"player.png"];
    
    cell.personImage.clipsToBounds = YES;
    cell.personImage.contentMode = UIViewContentModeScaleAspectFill;
    cell.personImage.layer.cornerRadius = 28.0;
    cell.personImage.layer.masksToBounds = YES;
    cell.personImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.personImage.layer.borderWidth = 0.3;
    
    int unreadCount = (int)[[self.unreadForTable objectAtIndex: [indexPath row]] integerValue];
    if (unreadCount > 0) {
        cell.unreadCount.text = [NSString stringWithFormat:@"%d", unreadCount];
        cell.unreadCount.hidden = FALSE;
        
        [cell.unreadCount sizeToFit];
        
        CGRect frame = cell.unreadCount.frame;
        
        frame.size.width = frame.size.width + 10;
        frame.size.height = frame.size.height + 10;
        
        cell.unreadCount.frame = frame;
        cell.unreadCount.layer.cornerRadius = 7.0;
    }
    else{
        cell.unreadCount.hidden = TRUE;
    }
    
    NSString *type = [self.userTypeForTable objectAtIndex: [indexPath row]];
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
    else if ([type isEqual: @"4"])
    {
        type = @"Coach";
    }
    
    cell.type.text = type;
    cell.message.text = [self.textForTable objectAtIndex: [indexPath row]];
    
    return cell;
}

-(void)load{
    
    self.dateForTable = [[NSMutableArray alloc]
                         initWithObjects:nil];
    
    self.textForTable = [[NSMutableArray alloc]
                         initWithObjects:nil];
    
    self.nameForTable  = [[NSMutableArray alloc]
                          initWithObjects:nil];
    
    self.imageForTable = [[NSMutableArray alloc]
                          initWithObjects:nil];
    
    self.userIDForTable = [[NSMutableArray alloc]
                           initWithObjects:nil];
    
    self.userTypeForTable = [[NSMutableArray alloc]
                             initWithObjects:nil];
    
    self.unreadForTable = [[NSMutableArray alloc]
                      initWithObjects:nil];
    
    //UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
    //self.myData = [NSMutableArray arrayWithCapacity:1];
    
    
    //int me = ViewController.playerID;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://newfootballers.com/get_messages.php/"]];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    //[request setHTTPBody:[[NSString stringWithFormat:@"u=%d", me]dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            //[self.delegate fetchingGroupsFailedWithError:error];
        } else {
            NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                                        options:0
                                                                          error:&error];
            dispatch_async(dispatch_get_main_queue(), ^{
                int count = 0;
                for(NSDictionary *dictionary in jsonArray)
                {
                    /*                    NSLog(@"Data Dictionary is : %@",dictionary);
                     NSLog(@"%@", [dictionary objectForKey:@"Firstname"]);*/
                    
                    [self.nameForTable addObject:[dictionary objectForKey:@"Firstname"]];
                    [self.imageForTable addObject:[dictionary objectForKey:@"PhotoURL"]];
                    [self.unreadForTable addObject:[dictionary objectForKey:@"UnreadCount"]];
                    
                    //get the date time in the iphone timezone
                    NSString *dateString = [dictionary objectForKey:@"SentDateTime"];
                    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                    //Special Locale for fixed dateStrings
                    NSLocale *locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US_POSIX"];
                    [formatter setLocale:locale];
                    //Assuming the dateString is in GMT+00:00
                    //formatter by default would be set to local timezone
                    NSTimeZone *timeZone = [NSTimeZone timeZoneWithAbbreviation:@"MDT"];
                    [formatter setTimeZone:timeZone];
                    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSDate *date =[formatter dateFromString:dateString];
                    //After forming the date set local time zone to formatter    
                    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
                    [formatter setTimeZone:localTimeZone];
                    NSString *newTimeZoneDateString = [formatter stringFromDate:date];
                    NSLog(@"%@",newTimeZoneDateString);
                    
                    //
                    NSDate *currentDate = [NSDate date];
                    NSCalendar* calendar = [NSCalendar currentCalendar];
                    NSDateComponents* today = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:currentDate]; // Get necessary date components
                    
                    NSDateComponents* components2 = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date]; // Get necessary date components
                    
                    if ([today year] == [components2 year] &&
                        [today month] == [components2 month] &&
                        [today day] == [components2 day]
                        ){
                        //today
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        [dateFormatter setDateFormat:@"HH:mm"];
                        NSString *time = [dateFormatter stringFromDate:date];
                        
                        [self.dateForTable addObject:time];
                    }
                    else if([today year] == [components2 year] &&
                            [today month] == [components2 month] &&
                            [today day] - 1 == [components2 day])
                    {
                        //yesterday
                        NSString *time = @"Yesterday";
                        
                        [self.dateForTable addObject:time];
                        
                    }
                    else
                    {
                        //another day
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        [dateFormatter setDateFormat:@"yyyy/MM/dd"];
                        NSString *time = [dateFormatter stringFromDate:date];
                        
                        [self.dateForTable addObject:time];
                        
                    }
                    
                    //[self.dateForTable addObject:[dictionary objectForKey:@"SentDateTime"]];
                    [self.textForTable addObject:[dictionary objectForKey:@"Text"]];
                    [self.userTypeForTable addObject:[dictionary objectForKey:@"UserType"]];
                    [self.userIDForTable addObject:[dictionary objectForKey:@"UserID"]];
                    
                    count++;
                }
                if (count <= 0){
                    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
                    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no-chats.png"]];
                    tempImageView.contentMode = UIViewContentModeBottom;
                    /*UIView *view = [[UIView alloc] initWithFrame:CGRectMake(200,200, 320, 430)];
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(200, 200, 450, 430)];
                    label.textColor = [UIColor whiteColor];
                    label.text = @"You have no chats";
                    label.textAlignment = NSTextAlignmentCenter;
                    [view addSubview:label];
                    self.tableView.tableHeaderView = label;*/
                    // Add image view on top of table view
                    [self.theTable addSubview:tempImageView];
                    [tempImageView setFrame:self.tableView.frame];
                    self.theTable.backgroundView = tempImageView;
                    self.theTable.alwaysBounceVertical = NO;
                }
                else{
                    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
                    self.tableView.tableHeaderView = nil;
                    self.theTable.backgroundView = Nil;
                    self.theTable.alwaysBounceVertical = YES;
                }
                [self.tableView reloadData];
                [self performSelector:@selector(stopRefresh) withObject:nil afterDelay:2.5];
            });
        }
    }];
}

- (void)stopRefresh
{
    [self.refreshControl endRefreshing];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.mainSlideMenu.panGesture.minimumNumberOfTouches = 2;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.mainSlideMenu.panGesture.minimumNumberOfTouches = 1;
}

/*
loads the view - we will get the users messages from the server so that they can choose which ones to read..
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //[controller disableSlidePanGestureForRightMenu];
    //[controller disableSlidePanGestureForLeftMenu];
    [self disableSlidePanGestureForLeftMenu];
    
    
    self.tableView.delegate = self;
    self.tableView.userInteractionEnabled=YES;
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Discover and be discovered"];
    [refresh addTarget:self action:@selector(load) forControlEvents:UIControlEventValueChanged];

    self.refreshControl = refresh;
    
    [self load];    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        int idx = (int)indexPath.row;
        NSString *o = [self.userIDForTable objectAtIndex:idx];
        int chattingToID = [o intValue];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://newfootballers.com/delete_message_convo.php/"]];
        [request setHTTPBody:[[NSString stringWithFormat:@"u=%d", chattingToID]dataUsingEncoding:NSUTF8StringEncoding]];
        [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
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
                        if ([[dictionary objectForKey:@"accepted"] intValue] == 1){
                            //delete
                            [self.dateForTable removeObjectAtIndex:idx];
                            [self.imageForTable removeObjectAtIndex:idx];
                            [self.textForTable removeObjectAtIndex:idx];
                            [self.nameForTable removeObjectAtIndex:idx];
                            [self.userTypeForTable removeObjectAtIndex:idx];
                            [self.userIDForTable removeObjectAtIndex:idx];
                            [self.locationForTable removeObjectAtIndex:idx];
                            [self.unreadForTable removeObjectAtIndex:idx];
                            
                            [self.tableView reloadData];
                            [self.theTable reloadData];
                        }
                        else{

                        }
                    });
                }
            }
        }];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


- (void)chatting:
(MessageCenterController *)controller update :(NSString *)date :(NSString *)text
                :(NSString *)unread : (int)idx;
{
    self.unreadForTable[idx] = unread;
    self.textForTable[idx] = text;
    self.dateForTable[idx] = date;
    
    [self.tableView reloadData];
    /*[self.dateForTable removeObjectAtIndex:idx];
    [self.imageForTable removeObjectAtIndex:idx];
    [self.textForTable removeObjectAtIndex:idx];
    [self.nameForTable removeObjectAtIndex:idx];
    [self.userTypeForTable removeObjectAtIndex:idx];
    [self.userIDForTable removeObjectAtIndex:idx];
    [self.locationForTable removeObjectAtIndex:idx];
    [self.unreadForTable removeObjectAtIndex:idx];*/
}



@end
