//
//  ChangePasswordController.m
//  theImage
//
//  Created by Andrew Buttigieg on 4/20/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import "ChangePasswordController.h"

@interface ChangePasswordController ()

@end

@implementation ChangePasswordController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)update:(id)sender {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://newfootballers.com/change_password.php/"]];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [request setHTTPBody:[[NSString stringWithFormat:@"oldpassword=%@&newpassword=%@", self.oldpwd.text, self.newpwd.text]dataUsingEncoding:NSUTF8StringEncoding]];
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
                                           NSLog(@"%@", self.oldpwd.text);
                                       });
                                   }
                                   
                               }
                           }];
    
}
@end
