//
//  LoginController.m
//  theImage
//
//  Created by Andrew Buttigieg on 3/5/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import "LoginController.h"
#import "KeychainItemWrapper.h"
#import "JNKeychain.h"
#import "ViewController.h"

@interface LoginController ()

@end

@implementation LoginController

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

- (IBAction)login:(id)sender {
    
    NSString *login = self.email.text;
    NSString *password = self.password.text;
    
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
            
            dispatch_async(dispatch_get_main_queue(), ^{
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
                /*    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"PlayerCVUDID" accessGroup:nil];
                 */
                   /*
                    PKOAuth2Token *token = [[PKOAuth2Token alloc] initWithAccessToken:@"access1234"
                                                                         refreshToken:@"refresh1234"
                                                                        transferToken:@"transfer1234"
                                                                            expiresOn:[NSDate dateWithTimeIntervalSinceNow:3600]
                                                                              refData:@{@"ref": @"somedata"}];
                    */
                    
                    NSString *keyLogin = @"login";
                    [JNKeychain saveValue:login forKey:keyLogin];
                    
                    NSString *keyPwd = @"pwd";
                    [JNKeychain saveValue:password forKey:keyPwd];
                    
                    NSString * storyboardName = @"Main_iPhone";
                    NSString * viewControllerID = @"Main";
                    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
                    ViewController * controller = (ViewController *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
                    
                    [self.navigationController pushViewController:controller animated:YES];
                    
                    /*
                    // Test archiving
                    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:token];
                    PKOAuth2Token *archivedToken = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                    NSLog(@"Restored access token from archive %@", archivedToken.accessToken);
                    
                    // Test keychain
                    NSString *keychainKey = @"AuthToken";
                    [JNKeychain saveValue:token forKey:keychainKey];
                    PKOAuth2Token *keychainToken = [JNKeychain loadValueForKey:keychainKey];
                    NSLog(@"Restored access token from keychain: %@", keychainToken.accessToken);
                    [keychain setObject:login forKey:(__bridge id)(kSecAttrAccount)];
                    */
                   // [keychain setObject:password forKey:(__bridge id)(kSecClassGenericPassword)];
                    
                 //   [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
                    
                }
            });
        }
    }

    
}
@end
