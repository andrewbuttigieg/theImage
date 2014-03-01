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
    /*
    // 4. Set the progress block of the operation.
    [operation setUploadProgressBlock:^(NSUInteger __unused bytesWritten,
                                        long long totalBytesWritten,
                                        long long totalBytesExpectedToWrite) {
        NSLog(@"Wrote %lld/%lld", totalBytesWritten, totalBytesExpectedToWrite);
    }];*/
    
    // 5. Begin!
    [operation start];
    /*
     if (imageData != nil && 1 == 2)
     {
     //NSData *data = [NSData dataWithContentsOfFile:filePath];
     NSMutableString *urlString = [[NSMutableString alloc] initWithFormat:@"name=thefile&filename="];
     [urlString appendFormat:@"%@", imageData];
     NSData *postData = [urlString dataUsingEncoding:NSASCIIStringEncoding
     allowLossyConversion:YES];
     NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
     
     
     NSURL *url = [NSURL URLWithString:baseurl];
     NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
     [urlRequest setHTTPMethod: @"POST"];
     [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
     [urlRequest setValue:@"application/x-www-form-urlencoded"
     forHTTPHeaderField:@"Content-Type"];
     
     [urlRequest setHTTPBody:postData];
     
     NSData *returnData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil];
     NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
     NSLog(returnString);
     
     NSLog(@"Started!");
     }*/
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
