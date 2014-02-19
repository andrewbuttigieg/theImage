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
#import "ChatController.h"

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
    
    
    /////////
    NSString * storyboardName = @"Main_iPhone";
    NSString * viewControllerID = @"ChatController";
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    ChatController * controller = (ChatController *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
//    controller.playerID = tappedView.tag;
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

    cell.personImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self.imageForTable objectAtIndex: [indexPath row]]]]];
    
    cell.personImage.layer.cornerRadius = 28.0;
    cell.personImage.layer.masksToBounds = YES;
    cell.personImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.personImage.layer.borderWidth = 0.3;
    
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
    /*
    else if ([type isEqual: @"4"])
    {
        type = @"";
    }*/
    cell.type.text = type;
    cell.message.text = [self.textForTable objectAtIndex: [indexPath row]];
    
    return cell;
}

/*
loads the view - we will get the users messages from the server so that they can choose which ones to read..
 */
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
    
    self.userTypeForTable = [[NSMutableArray alloc]
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
            NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                                        options:0
                                                                          error:&error];
            dispatch_async(dispatch_get_main_queue(), ^{
                for(NSDictionary *dictionary in jsonArray)
                {
                    NSLog(@"Data Dictionary is : %@",dictionary);
                    NSLog(@"%@", [dictionary objectForKey:@"Firstname"]);
                                    
                    [self.nameForTable addObject:[dictionary objectForKey:@"Firstname"]];
                    [self.imageForTable addObject:[dictionary objectForKey:@"PhotoURL"]];
                    [self.dateForTable addObject:[dictionary objectForKey:@"Timestamp"]];
                    [self.textForTable addObject:[dictionary objectForKey:@"Text"]];
                    [self.userTypeForTable addObject:[dictionary objectForKey:@"UserType"]];
                    [self.userIDForTable addObject:[dictionary objectForKey:@"UserID"]];
                }
                [self.tableView reloadData];
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
