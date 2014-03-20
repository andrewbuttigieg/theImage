//
//  FriendRequestsController.m
//  theImage
//
//  Created by Andrew Buttigieg on 3/20/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import "FriendRequestsController.h"
#import "friendCell.h"


@interface FriendRequestsController ()

@end

@implementation FriendRequestsController

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
    return [self.dateForFR count];
}

/*
 This sets the value of the items in the cell
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"friendCell";
    
    friendCell *cell = [tableView
                              dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[friendCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.name.text = [self.nameForFR
                      objectAtIndex: [indexPath row]];
    cell.date.text = [self.dateForFR
                      objectAtIndex: [indexPath row]];
    
    cell.personImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self.imageForFR objectAtIndex: [indexPath row]]]]];
    
    cell.personImage.layer.cornerRadius = 28.0;
    cell.personImage.layer.masksToBounds = YES;
    cell.personImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.personImage.layer.borderWidth = 0.3;
    
    NSString *type = [self.userTypeForFR objectAtIndex: [indexPath row]];
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
    cell.message.text = [self.textForFR objectAtIndex: [indexPath row]];
    
    return cell;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.dateForFR =[[NSMutableArray alloc]
                         initWithObjects:nil];
    
    /*self.textForFR =[[NSMutableArray alloc]
                         initWithObjects:nil];*/
    
    self.nameForFR  = [[NSMutableArray alloc]
                          initWithObjects:nil];
    
    self.imageForFR =[[NSMutableArray alloc]
                          initWithObjects:nil];
    
    self.userIDForFR =[[NSMutableArray alloc]
                           initWithObjects:nil];
    
    self.userTypeForFR =[[NSMutableArray alloc]
                             initWithObjects:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://newfootballers.com/get_friend_requests.php"]];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [request setHTTPMethod:@"POST"];
    
    self.title = @"Friend Requests";
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            //[self.delegate fetchingGroupsFailedWithError:error];
        } else {
            //[self.delegate receivedGroupsJSON:data];
            NSError *localError = nil;
            NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                                        options:0
                                                                          error:&error];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                for(NSDictionary *dictionary in jsonArray)
                {
                    NSLog(@"%@", dictionary);
                    [self.nameForFR addObject:[dictionary objectForKey:@"Firstname"]];
                    [self.imageForFR addObject:[dictionary objectForKey:@"PhotoURL"]];
                    [self.dateForFR addObject:[dictionary objectForKey:@"Created"]];
                    //[self.textForFR addObject:[dictionary objectForKey:@"Text"]];
                    [self.userTypeForFR addObject:[dictionary objectForKey:@"UserType"]];
                    [self.userIDForFR addObject:[dictionary objectForKey:@"UserID"]];
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



/*
// Override to support conditional editing of the FR view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the FR view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the FR view
    }   
}
*/

/*
// Override to support rearranging the FR view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the FR view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
