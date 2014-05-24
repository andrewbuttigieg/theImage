//
//  ChangePasswordController.h
//  theImage
//
//  Created by Andrew Buttigieg on 4/20/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePasswordController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *oldpwd;
@property (strong, nonatomic) IBOutlet UITextField *newpwd;

- (IBAction)update:(id)sender;

@end
