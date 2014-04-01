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
#import "ViewController.h"

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
    
    self.scrollview.contentSize = CGSizeMake(320, 1433);
    /*CGPoint bottomOffset = CGPointMake(0, 180);
    [self.scrollview setContentOffset:bottomOffset animated:YES];
    */
    
    self.scrollview.contentSize = CGSizeMake(320, 1433);
    [self.scrollview setContentSize:(CGSizeMake(320, 1433))];

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
    
    self.genderArray =  [[NSArray alloc]initWithObjects:@"Male",@"Female",@"Hidden" , nil];
    self.picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 100, 150)];
    [self.picker setDataSource: self];
    [self.picker setDelegate: self];
    self.picker.showsSelectionIndicator = YES;
    
    self.gender.inputView = self.picker;
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://newfootballers.com/get_me.php"]];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [request setHTTPMethod:@"POST"];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
        } else {
            //NSError *localError = nil;
            NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                                        options:0
                                                                          error:&error];
            NSLog(@"Data Dictionary is : %@", jsonArray);
            dispatch_async(dispatch_get_main_queue(), ^{
                for(NSDictionary *dictionary in jsonArray)
                {
                    //NSString *imageURL = [dictionary objectForKey:@"PhotoURL"];

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
                    
                    
                    NSString *imageURL = [dictionary objectForKey:@"PhotoURL"];
                    if ([imageURL length] > 5){
                        [self.toUpload setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]] forState:UIControlStateNormal];
                        
                    }
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

- (BOOL) textField: (UITextField *)theTextField shouldChangeCharactersInRange:(NSRange)range replacementString: (NSString *)string {
    //return yes or no after comparing the characters
    
    // allow backspace
    if (!string.length)
    {
        return YES;
    }
    
    if (self.activePlayerTextField != self.age &&
        self.activePlayerTextField != self.weight &&
        self.activePlayerTextField != self.height){
        return  YES;
    }
    ////for Decimal value start//////This code use use for allowing single decimal value
    //    if ([theTextField.text rangeOfString:@"."].location == NSNotFound)
    //    {
    //        if ([string isEqualToString:@"."]) {
    //            return YES;
    //        }
    //    }
    //    else
    //    {
    //        if ([[theTextField.text substringFromIndex:[theTextField.text rangeOfString:@"."].location] length]>2)   // this allow 2 digit after decimal
    //        {
    //            return NO;
    //        }
    //    }
    ////for Decimal value End//////This code use use for allowing single decimal value
    
    if (([string isEqualToString:@"."] || [string isEqualToString:@","]) &&
        ([self.activePlayerTextField.text rangeOfString:@"," options:NSCaseInsensitiveSearch].length > 0 ||
         [self.activePlayerTextField.text rangeOfString:@"." options:NSCaseInsensitiveSearch].length > 0)){
        return NO;
    }
    
    // allow digit 0 to 9
    if ([string intValue] || [string isEqualToString:@"0"] || [string isEqualToString:@"."] || [string isEqualToString:@","])
    {
        return YES;
    }
    

    
    return NO;
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

-(void) uploadImage:(UIImage*)image {
    NSData *imageData = UIImageJPEGRepresentation(image, 0.2);     //change Image to NSData
    NSString *baseurl = @"http://newfootballers.com/upload_image.php";
    NSDictionary *parameters = @{@"t": @"Profile photo", @"n": @"Profile photo"};
    
    // 1. Create `AFHTTPRequestSerializer` which will create your request.
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    
    // 2. Create an `NSMutableURLRequest`.
    NSMutableURLRequest *request =
    [serializer multipartFormRequestWithMethod:@"POST" URLString:baseurl
                                    parameters:parameters
                     constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                         [formData appendPartWithFileData:imageData
                                                     name:@"attachment"
                                                 fileName:[NSString stringWithFormat:@"%d-profile.jpg", ViewController.playerID]
                                                 mimeType:@"image/jpeg"];
                     }];
    

    // 3. Create and use `AFHTTPRequestOperationManager` to create an `AFHTTPRequestOperation` from the `NSMutableURLRequest` that we just created.
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestOperation *operation =
    [manager HTTPRequestOperationWithRequest:request
                                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                         NSLog(@"Success %@", responseObject);
                                         //
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
    [request setHTTPBody:[[NSString stringWithFormat:@"h=%@&w=%@&a=%@&p=%@&u=1&name=%@&surname=%@&phone=%@&email=%@",
                           self.height.text, self.weight.text, self.about.text,self.position.text, self.name.text, self.surname.text,self.phone.text, self.email.text]dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    NSError *error = nil; NSURLResponse *response = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error) {
        NSLog(@"Error:%@", error.localizedDescription);
    }
    else {
        //success
        NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:0
                                                                      error:&error];
        NSLog(@"Data Dictionary is : %@", jsonArray);
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
    // Dismiss the image selection, hide the picker and
    //show the image view with the picked image
    [picker dismissModalViewControllerAnimated:YES];
//    self.toUpload.image = image;
    
    [self.toUpload setBackgroundImage:image forState:UIControlStateNormal];
    
    [self uploadImage:image];
}

- (IBAction)findImage:(id)sender {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentModalViewController:imagePickerController animated:YES];

}

- (IBAction)lookingForPlayer:(id)sender {
    if (self.lookingForPlayerButton.on){
        CGRect frame = self.privateInformationView.frame;
        frame.origin.y=self.lookingForPlayerButton.frame.origin.y + 44 + 100;//pass the cordinate which you want
        self.privateInformationView.frame= frame;
    }
    else{
        CGRect frame = self.privateInformationView.frame;
        frame.origin.y=self.lookingForPlayerButton.frame.origin.y + 44 + 18;//pass the cordinate which you want
        self.privateInformationView.frame= frame;
    }
}
- (IBAction)genderClick:(id)sender {
}

#pragma mark -
#pragma mark PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return self.genderArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return [self.genderArray objectAtIndex:row];
}

#pragma mark -
#pragma mark PickerView Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    NSString *genderX = self.genderArray[row];
    
/*    NSString *resultString = [[NSString alloc] initWithFormat:
                              @"%.2f USD = %.2f %@", dollars, result,
                              _countryNames[row]];*/

    self.gender.text = genderX;
}


@end
