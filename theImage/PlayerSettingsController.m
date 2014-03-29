//
//  PlayerSettingsController.m
//  theImage
//
//  Created by Andrew Buttigieg on 1/12/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import "PlayerSettingsController.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import <AFNetworking/AFHTTPRequestOperation.h>
#import <AFNetworking/AFURLResponseSerialization.h>
#import <AFNetworking/AFHTTPSessionManager.h>


@interface PlayerSettingsController ()

@end

@implementation PlayerSettingsController

CGSize keyboardSize;
bool movedAlready = false;

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
    self.title = @"Edit Profile";
    
    self.scrollview.contentSize = CGSizeMake(320, 833);
    CGPoint bottomOffset = CGPointMake(0, 180);
    [self.scrollview setContentOffset:bottomOffset animated:YES];
    
    self.scrollview.contentSize = CGSizeMake(320, 833);
    [self.scrollview setContentSize:(CGSizeMake(320, 833))];

    self.scrollview.userInteractionEnabled=YES;
    [self.scrollview setScrollEnabled:YES];
    
    self.about.delegate = self;
    self.height.delegate = self;
    self.weight.delegate = self;
    self.email.delegate = self;
    self.position.delegate = self;
    self.age.delegate = self;
    self.gender.delegate = self;
    self.email.delegate = self;
    self.phone.delegate = self;
    self.name.delegate = self;
    self.surname.delegate = self;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://newfootballers.com/get_me.php"]];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [request setHTTPMethod:@"POST"];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
        } else {
            NSError *localError = nil;
            NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                                        options:0
                                                                          error:&error];
            NSLog(@"Data Dictionary is : %@", jsonArray);
            dispatch_async(dispatch_get_main_queue(), ^{
                for(NSDictionary *dictionary in jsonArray)
                {
                    NSString *imageURL = [dictionary objectForKey:@"PhotoURL"];

                    self.about.text = [dictionary objectForKey:@"About"] ;
                    self.height.text = [dictionary objectForKey:@"Height"];
                    self.weight.text = [dictionary objectForKey:@"Weight"];
                    self.email.text = [dictionary objectForKey:@"Email"];
                    self.position.text = [dictionary objectForKey:@"Position"];
                    self.age.text = [dictionary objectForKey:@"Age"];
                    self.gender.text = [dictionary objectForKey:@"Gender"];
                    self.email.text = [dictionary objectForKey:@"Email"];
                    if ([dictionary objectForKey:@"Phone"] != [NSNull null]){
                        self.phone.text = [dictionary objectForKey:@"Phone"];
                    }
                    self.name.text = [dictionary objectForKey:@"Firstname"];
                    self.surname.text = [dictionary objectForKey:@"Lastname"];
                    
                    /*
                    if ([imageURL length] > 5){
                        self.toUpload.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
                    }*/
                }
            });
        }
    }];


    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)dismissKeyboard:(id)sender
{
    [self.activePlayerTextField resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activePlayerTextField = textField;
    
    if (movedAlready){
        CGRect aRect = self.view.frame;
        aRect.size.height -= keyboardSize.height;
        CGPoint scrollPoint = CGPointMake(0.0, self.activePlayerTextField.frame.origin.y - (keyboardSize.height-35));
        [self.scrollview setContentOffset:scrollPoint animated:YES];
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.activePlayerTextField = nil;
    
}


- (void) keyboardWillHide:(NSNotification *)notification {
    movedAlready = false;
}

- (void)keyboardWasShown:(NSNotification *)notification
{
    keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    CGRect aRect = self.view.frame;
    aRect.size.height -= keyboardSize.height;
    CGRect rect = [[UIApplication sharedApplication] statusBarFrame];
    CGPoint xxx = self.activePlayerTextField.frame.origin;
    xxx.y += self.navigationController.navigationBar.frame.size.height + rect.size.height;
    
    if (!CGRectContainsPoint(aRect, xxx) ) {
        CGPoint scrollPoint = CGPointMake(0.0, self.activePlayerTextField.frame.origin.y - (keyboardSize.height-35));
        [self.scrollview setContentOffset:scrollPoint animated:YES];
    }
    movedAlready = true;
}

///////////


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)uploadImage:(id)sender {
    NSData *imageData = UIImageJPEGRepresentation(self.toUpload.image, 0.2);     //change Image to NSData
    NSString *baseurl = @"http://newfootballers.com/upload_image.php";
    NSDictionary *parameters = @{@"u": @"1", @"t": @"having fun!", @"n": @"Winning!"};
    
    // 1. Create `AFHTTPRequestSerializer` which will create your request.
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    
    // 2. Create an `NSMutableURLRequest`.
    NSMutableURLRequest *request =
    [serializer multipartFormRequestWithMethod:@"POST" URLString:baseurl
                                    parameters:parameters
                     constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                         [formData appendPartWithFileData:imageData
                                                     name:@"attachment"
                                                 fileName:@"myimage.jpg"
                                                 mimeType:@"image/jpeg"];
                     }];
    
    // 3. Create and use `AFHTTPRequestOperationManager` to create an `AFHTTPRequestOperation` from the `NSMutableURLRequest` that we just created.
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestOperation *operation =
    [manager HTTPRequestOperationWithRequest:request
                                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                         NSLog(@"Success %@", responseObject);
                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         NSLog(@"Failure %@", error.description);
                                     }];
    [operation start];
}

- (IBAction)save_player:(id)sender {
    
//    NSString *postData = [NSString stringWithFormat:@"h=%@&w=/%@&a=/%@&p=/%@&u=/%@", 1, self.position.text,  self.about.text,
  //                          self.weight.text, self.height.text	];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://newfootballers.com/update_user.php/"]];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [request setHTTPBody:[[NSString stringWithFormat:@"h=%@&w=%@&a=%@&p=%@&u=1",
                           self.height.text, self.weight.text, self.about.text,self.position.text]dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    NSError *error = nil; NSURLResponse *response = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error) {
        NSLog(@"Error:%@", error.localizedDescription);
    }
    else {
        //success
    }
    
}

@end
