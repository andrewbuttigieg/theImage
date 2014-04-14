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
bool player = false;

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
    
    self.lfpCountry.delegate = self;
    self.lfpPosition.delegate = self;
    
    self.surname.delegate = self;
    self.phone.delegate = self;
    
    self.lfpartCountry.delegate = self;
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://newfootballers.com/get_country.php"]];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
        } else {
            //NSError *localError = nil;
            NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                                        options:0
                                                                          error:&error];
//            NSLog(@"Data Dictionary is : %@", jsonArray);
            for(NSDictionary *dictionary in jsonArray)
            {
                //NSLog(@"%@", [dictionary objectForKey:@"Country"]);
                [self.countryArray addObject:[dictionary objectForKey:@"Country"]];
            }
            //[self.countryArray addObject:nil];
        }
    }];
                           
    
    self.genderArray =  [[NSMutableArray alloc]initWithObjects:@"Male",@"Female",@"Hidden" , nil];
    self.countryArray =  [[NSMutableArray alloc]initWithObjects:nil];

    
    self.picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 100, 150)];
    self.countryPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 100, 150)];
    self.countryPicker2 = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 100, 150)];
    
    [self.picker setDataSource: self];
    [self.picker setDelegate: self];
    self.picker.showsSelectionIndicator = YES;
    
    [self.countryPicker setDataSource: self];
    [self.countryPicker setDelegate: self];
    self.countryPicker.showsSelectionIndicator = YES;
    
    [self.countryPicker2 setDataSource: self];
    [self.countryPicker2 setDelegate: self];
    self.countryPicker2.showsSelectionIndicator = YES;
    
    self.gender.inputView = self.picker;
    self.lfpCountry.inputView = self.countryPicker;
    self.lfpartCountry.inputView = self.countryPicker2;
    
    [self lookingForPlayerAlign];
    
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://newfootballers.com/get_me.php"]];
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
                    
                    if ([dictionary objectForKey:@"LFPCountry"] && ![[dictionary objectForKey:@"LFPCountry" ] isKindOfClass:[NSNull class]]){
                        self.lfpCountry.text = [dictionary objectForKey:@"LFPCountry"];
                    }
                    if ([dictionary objectForKey:@"LFPPosition"] && ![[dictionary objectForKey:@"LFPPosition" ] isKindOfClass:[NSNull class]]){
                        self.lfpPosition.text = [dictionary objectForKey:@"LFPPosition"];
                    }
                    if ([dictionary objectForKey:@"PartnerCountry"] && ![[dictionary objectForKey:@"PartnerCountry" ] isKindOfClass:[NSNull class]]){
                        self.lfpartCountry.text = [dictionary objectForKey:@"PartnerCountry"];
                    }
                    
                    if ([[dictionary objectForKey:@"UserType"] intValue] == 1){
                        //player
                        player = false;
                        self.lookingForPartnerView.hidden = TRUE;
                        self.lookingForPlayer.hidden = TRUE;
                        self.lookingForPartnerSwitch.hidden = TRUE;
                        self.lookingForPlayerSwitch.hidden = TRUE;
                        self.marketLabel.hidden = TRUE;
                    }
                    else{
                        //not a player
                        if ([dictionary objectForKey:@"LookingForPlayer"] && ![[dictionary objectForKey:@"LookingForPlayer" ] isKindOfClass:[NSNull class]]){

                            if ([[dictionary objectForKey:@"LookingForPlayer"] intValue] == 1){
                                self.lookingForPlayerButton.on = TRUE;
                            }
                            
                            else{
                                self.lookingForPlayerButton.on = FALSE;
                            }
                        }
                        else{
                            self.lookingForPlayerButton.on = FALSE;
                        }
                        if ([dictionary objectForKey:@"LookingForPartnership"] && ![[dictionary objectForKey:@"LookingForPartnership" ] isKindOfClass:[NSNull class]]){

                            if ([[dictionary objectForKey:@"LookingForPartnership"] boolValue]){
                                self.lookingForPartnerButton.on = TRUE;
                            }
                            else{
                                self.lookingForPartnerButton.on = FALSE;
                            }
                        }
                        else{
                            self.lookingForPartnerButton.on = FALSE;
                        }
                    }
                    NSString *imageURL = [dictionary objectForKey:@"PhotoURL"];
                    if ([imageURL length] > 5){
                        [self.toUpload setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]] forState:UIControlStateNormal];
                        
                    }
                    
                    [self lookingForPlayerAlign];
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
        self.activePlayerTextField != self.height &&
        self.activePlayerTextField != self.phone){
        return  YES;
    }
    
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
    float topY = 0;
    if ([textField isEqual: self.lfpPosition] || [textField isEqual: self.lfpCountry]){
        topY = self.lookingForPlayer.frame.origin.y;
    }
    
    if ([textField isEqual:self.lfpartCountry]){
        topY = self.lookingForPartnerSwitch.frame.origin.y;
    }
    
    if ([textField isEqual:self.email] || [textField isEqual:self.phone]){
        topY = self.privateInformationView.frame.origin.y;
    }
    
    if (movedAlready){
        CGRect aRect = self.view.frame;
        aRect.size.height -= keyboardSize.height;
        CGPoint scrollPoint = CGPointMake(0.0, self.activePlayerTextField.frame.origin.y + topY - (keyboardSize.height-35));
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
    
    float topY = 0;
    if ([self.activePlayerTextField isEqual: self.lfpPosition] || [self.activePlayerTextField isEqual: self.lfpCountry]){
        topY = self.lookingForPlayer.frame.origin.y;
    }
    if ([self.activePlayerTextField isEqual:self.lfpartCountry]){
        topY = self.lookingForPartnerSwitch.frame.origin.y;
    }
    if ([self.activePlayerTextField isEqual:self.email] || [self.activePlayerTextField isEqual:self.phone]){
        topY = self.privateInformationView.frame.origin.y;
    }

    CGRect aRect = self.view.frame;
    aRect.size.height -= keyboardSize.height;
    CGRect rect = [[UIApplication sharedApplication] statusBarFrame];
    CGPoint xxx = self.activePlayerTextField.frame.origin;
    xxx.y +=  topY + self.navigationController.navigationBar.frame.size.height + rect.size.height;
    
    if (!CGRectContainsPoint(aRect, xxx) ) {
        CGPoint scrollPoint = CGPointMake(0.0, self.activePlayerTextField.frame.origin.y + topY - (keyboardSize.height-35));
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
    [request setHTTPBody:[[NSString stringWithFormat:@"h=%@&w=%@&a=%@&p=%@&u=1&name=%@&surname=%@&phone=%@&email=%@&lookingForPlayer=%@&lfpCountry=%@&lfpPosition=%@&lookingForPartnership=%@&partnerCountry=%@",
                           self.height.text, self.weight.text, self.about.text,self.position.text, self.name.text, self.surname.text,self.phone.text, self.email.text,
                           self.lookingForPlayerButton.on ? @"1" : @"0",
                           self.lfpCountry.text, self.lfpPosition.text,
                           self.lookingForPartnerButton.on ? @"1" : @"0",
                           self.lfpartCountry.text
                           ]dataUsingEncoding:NSUTF8StringEncoding]];
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

- (void) lookingForPlayerAlign {
    
    if (self.lookingForPlayerButton.on){
        CGRect frame = self.lookingForPartnerSwitch.frame;
        frame.origin.y = self.lookingForPlayer.frame.origin.y +
                        self.lookingForPlayer.frame.size.height + 18;//pass the cordinate which you want
        
        self.lookingForPartnerSwitch.frame= frame;
        self.lookingForPlayer.hidden = FALSE;
    }
    else{
        CGRect frame = self.lookingForPartnerSwitch.frame;
        frame.origin.y = self.lookingForPlayerSwitch.frame.origin.y +
                        self.lookingForPlayerSwitch.frame.size.height + 18;//pass the cordinate which you want
        
        self.lookingForPartnerSwitch.frame= frame;
        self.lookingForPlayer.hidden = TRUE;
    }
    
    CGRect frame2 = self.lookingForPartnerView.frame;
    frame2.origin.y = self.lookingForPartnerSwitch.frame.origin.y
        + self.lookingForPartnerSwitch.frame.size.height;
    self.lookingForPartnerView.frame= frame2;
    
    if (self.lookingForPartnerButton.on){
        if (!player){
            CGRect frame = self.privateInformationView.frame;
            int y = self.lookingForPartnerView.frame.origin.y +
                self.lookingForPartnerView.frame.size.height + 18;
            frame.origin.y = y;//pass the cordinate which you want
        
            self.privateInformationView.frame= frame;
            self.lookingForPartnerView.hidden = FALSE;
        }
    }
    else{
        
        if (!player){
            CGRect frame = self.privateInformationView.frame;
            int y = self.lookingForPartnerSwitch.frame.origin.y +
            self.lookingForPartnerSwitch.frame.size.height + 18;
            frame.origin.y = y;//pass the cordinate which you want
            
            self.privateInformationView.frame= frame;
            self.lookingForPartnerView.hidden = TRUE;
        }
    }
    
    
    /*
    if (self.lookingForPlayerButton.on){
        CGRect frame = self.privateInformationView.frame;
        frame.origin.y = self.lookingForPartnerView.frame.origin.y +
                        self.lookingForPartnerView.frame.size.height + 18;
        
        self.privateInformationView.frame= frame;
        self.lookingForPlayer.hidden = FALSE;
    }
    else{
        CGRect frame = self.privateInformationView.frame;
        frame.origin.y = self.lookingForPartnerView.frame.origin.y +
            self.lookingForPartnerView.frame.size.height + 18;
        
        self.privateInformationView.frame= frame;
        self.lookingForPlayer.hidden = TRUE;
    }*/
    
    self.scrollview.contentSize = CGSizeMake(320, self.privateInformationView.frame.origin.y + self.privateInformationView.frame.size.height + 10);
}

- (IBAction)lookingForPlayer:(id)sender {
    [self lookingForPlayerAlign];

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
    if([pickerView isEqual: self.picker]){
        return self.genderArray.count;
    }
    else if ([pickerView isEqual: self.countryPicker]){
        return [self.countryArray count];
    }
    else if ([pickerView isEqual: self.countryPicker2]){
        return [self.countryArray count];
    }
    else{
        return 0;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    if([pickerView isEqual: self.picker]){
        return [self.genderArray objectAtIndex:row];
    }
    else if ([pickerView isEqual: self.countryPicker]){
        if (row < [self.countryArray count]){
            return [self.countryArray objectAtIndex:row];
        }
        else{
            return NULL;
        }
    }
    else if ([pickerView isEqual: self.countryPicker2]){
        if (row < [self.countryArray count]){
            return [self.countryArray objectAtIndex:row];
        }
        else{
            return NULL;
        }
    }
    else{
        return NULL;
    }
}

#pragma mark -
#pragma mark PickerView Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    if([pickerView isEqual: self.picker]){
        NSString *genderX = self.genderArray[row];
        self.gender.text = genderX;
    }
    else if ([pickerView isEqual: self.countryPicker]){
        NSString *country = self.countryArray[row];
        self.lfpCountry.text = country;
    }
    else if ([pickerView isEqual: self.countryPicker2]){
        NSString *country = self.countryArray[row];
        self.lfpartCountry.text = country;
    }
    else{

    }
}


- (IBAction)lookingForPartner:(id)sender {
    [self lookingForPlayerAlign];
}
@end
