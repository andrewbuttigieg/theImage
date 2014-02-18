//
//  MessageCenterController.m
//  theImage
//
//  Created by Andrew Buttigieg on 2/10/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import "MessageCenterController.h"
#import "ViewController.h"
#import "messageGroupCell.h"

@interface MessageCenterController ()

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
    
    int idx=indexPath.row;
    NSString *o = [self.userIDForTable objectAtIndex:idx];
    self.textForTable = self.textForTable;
}


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

    cell.personImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self.imageForTable objectAtIndex: [indexPath row]]]]];
    
     
    cell.message.text = [self.textForTable
                      objectAtIndex: [indexPath row]];
    
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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

    
    UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
    self.myData = [NSMutableArray arrayWithCapacity:1];
    
    
    int me = ViewController.playerID;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://newfootballers.com/get_messages.php/"]];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [request setHTTPBody:[[NSString stringWithFormat:@"u=%d", me]dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            //[self.delegate fetchingGroupsFailedWithError:error];
        } else {
            //[self.delegate receivedGroupsJSON:data];
            //NSError *localError = nil;
            NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                                        options:0
                                                                          error:&error];
            for(NSDictionary *dictionary in jsonArray)
            {
                NSLog(@"Data Dictionary is : %@",dictionary);
                /*NSString *imageURL = [dictionary objectForKey:@"PhotoURL"];
                NSLog(@"%@", imageURL);*/
                NSLog(@"%@", [dictionary objectForKey:@"Firstname"]);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.nameForTable addObject:[dictionary objectForKey:@"Firstname"]];
                    [self.imageForTable addObject:[dictionary objectForKey:@"PhotoURL"]];
                    [self.dateForTable addObject:[dictionary objectForKey:@"Timestamp"]];
                    [self.textForTable addObject:[dictionary objectForKey:@"Text"]];
                    [self.userIDForTable addObject:[dictionary objectForKey:@"UserID"]];
                    [self.tableView reloadData];
                    //get the player information
                 /*   self.playerName.text = [dictionary objectForKey:@"Firstname"];
                    self.height.text = [dictionary objectForKey:@"Height"];
                    self.weight.text = [dictionary objectForKey:@"Weight"];
                    self.postion.text = [dictionary objectForKey:@"Position"];*/
                });
            }
        }
    }];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
