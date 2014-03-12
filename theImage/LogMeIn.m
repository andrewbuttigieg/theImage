//
//  LogMeIn.m
//  theImage
//
//  Created by Andrew Buttigieg on 3/9/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import "LogMeIn.h"
#import "JNKeychain.h"
#import "ViewController.h"

@interface LogMeIn ()

@end

@implementation LogMeIn

+ (BOOL)logout
{
    NSString *keyLogin = @"login";
    [JNKeychain deleteValueForKey:keyLogin];
    
    NSString *keyPwd = @"pwd";
    [JNKeychain deleteValueForKey:keyPwd];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://newfootballers.com/logout.php/"]];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [request setHTTPMethod:@"POST"];
    NSError *error = nil; NSURLResponse *response = nil;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    return true;
}

+ (BOOL)login:(NSString*)login :(NSString*)password
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://newfootballers.com/login_player.php/"]];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [request setHTTPBody:[[NSString stringWithFormat:@"password=%@&email=%@",
                           password, login]dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    NSError *error = nil; NSURLResponse *response = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error) {
        NSLog(@"Error:%@", error.localizedDescription);
    }
    else {
        //success
        NSLog(@"%@", data);
        NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:0
                                                                      error:&error];
        NSLog(@"%@", jsonArray);
        for(NSDictionary *dictionary in jsonArray)
        {
            //NSLog(@"Data Dictionary is : %@",jsonArray);
            NSString *returned = [jsonArray[0] objectForKey:@"value"];
            int accepted = [[jsonArray[0] objectForKey:@"accepted"] intValue];
            
            //dispatch_async(dispatch_get_main_queue(), ^{
                if (accepted == 0){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Problem"
                                                                    message:[NSString stringWithFormat:@"%@",returned]
                                                                   delegate:self
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                    [alert show];
                }
                else{
                    //keep the crediental for next time....
                    NSString *keyLogin = @"login";
                    [JNKeychain saveValue:login forKey:keyLogin];
                    
                    NSString *keyPwd = @"pwd";
                    [JNKeychain saveValue:password forKey:keyPwd];
                    
                    return true;
                }
           // });
        }
    }
    return false;
}

@end
