//
//  StartController.m
//  theImage
//
//  Created by Andrew Buttigieg on 3/5/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import "StartController.h"
#import "KeychainItemWrapper.h"
#import "JNKeychain.h"

@interface StartController ()

@end

@implementation StartController

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
    
    
    /*KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"TestUDID" accessGroup:nil];
    
    NSString *login = [keychain objectForKey:(__bridge id)(kSecAttrAccount)];
    NSString *pwd = [keychain objectForKey:(__bridge id)(kSecClassGenericPassword)];*/
    
    NSString *keyLogin = @"login";
    NSString *keyPwd = @"pwd";
    NSString *login = [JNKeychain loadValueForKey:keyLogin];
    NSString *pwd = [JNKeychain loadValueForKey:keyPwd];
    
     //[keychain setObject:password forKey:(__bridge id)(kSecValueData)];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
