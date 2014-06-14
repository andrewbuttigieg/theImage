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
#import "PlayerController.h"
#import "ValidURL.h"


@class PlayerSettingsController;


@implementation PlayerSettingsController

CGSize keyboardSize;
bool movedAlready = false;
bool player = false;
//1, 2, 3, 4, 5 -> what image in the list to upload
static int updateImage = 1;


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
    //self.delegate = self;
    
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
            [self.countryArray addObject:@""];
            for(NSDictionary *dictionary in jsonArray)
            {
                [self.countryArray addObject:[dictionary objectForKey:@"Country"]];
            }
        }
    }];
                           
    
    self.genderArray =  [[NSMutableArray alloc]initWithObjects:@"", @"Male",@"Female",@"Hidden" , nil];
    self.countryArray =  [[NSMutableArray alloc]initWithObjects:nil];
    
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://newfootballers.com/get_playing_position.php"]];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
        } else {
            //NSError *localError = nil;
            NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                                        options:0
                                                                          error:&error];
            [self.positionArray addObject:@""];
            for(NSDictionary *dictionary in jsonArray)
            {
                [self.positionArray addObject:[dictionary objectForKey:@"Text"]];
            }
        }
    }];
    self.positionArray =  [[NSMutableArray alloc]initWithObjects:nil];
    
   /* self.positionArray =[[NSMutableArray alloc]initWithObjects:@"", @"Goalkeeper (GK)",
    @"Defender Left (DL)",
    @"Defender Right (DR)",
    @"Defender Centre (DC)",
    @"Midfielder Left (ML)",
    @"Midfielder Right (MR)",
    @"Defensive Midfielder Centre (DMC)",
    @"Midfielder Centre (MC)",
    @"Attacking Midfielder Centre (AMC)",
    @"Forward (FW)",
    @"Striker (ST)" , nil];*/

    self.positionPicker= [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 100, 150)];
    self.positionPicker2= [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 100, 150)];
    self.picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 100, 150)];
    self.countryPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 100, 150)];
    self.countryPicker2 = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 100, 150)];

    [self.positionPicker setDataSource: self];
    [self.positionPicker setDelegate: self];
    self.positionPicker.showsSelectionIndicator = YES;
    
    [self.positionPicker2 setDataSource: self];
    [self.positionPicker2 setDelegate: self];
    self.positionPicker2.showsSelectionIndicator = YES;
    
    [self.picker setDataSource: self];
    [self.picker setDelegate: self];
    self.picker.showsSelectionIndicator = YES;
    
    [self.countryPicker setDataSource: self];
    [self.countryPicker setDelegate: self];
    self.countryPicker.showsSelectionIndicator = YES;
    
    [self.countryPicker2 setDataSource: self];
    [self.countryPicker2 setDelegate: self];
    self.countryPicker2.showsSelectionIndicator = YES;
    //all the pickers are binded to their respective input view
    self.position.inputView = self.positionPicker;
    self.gender.inputView = self.picker;
    self.lfpPosition.inputView = self.positionPicker2;
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

                    if (
                        [dictionary objectForKey:@"About"] != [NSNull null] &&
                        [dictionary objectForKey:@"About"] != nil
                        ){
                        self.about.text = [dictionary objectForKey:@"About"];
                    }
                    
                    if ([[dictionary objectForKey:@"Height"] floatValue] > 1){
                        self.height.text = [dictionary objectForKey:@"Height"];
                    }
                    else{
                        self.height.text = @"";
                    }
                    if ([[dictionary objectForKey:@"Weight"] floatValue] > 1){
                        self.weight.text = [dictionary objectForKey:@"Weight"];
                    }
                    else{
                        self.weight.text = @"";
                    }
                    self.email.text = [dictionary objectForKey:@"Email"];
                    
                    if ([[dictionary objectForKey:@"Position"] isEqual:[NSNull null]] ||
                        [dictionary objectForKey:@"Position"] != nil ||
                        [[dictionary objectForKey:@"Position"] isEqualToString:@"0"] ||
                        [[dictionary objectForKey:@"Position"] isEqualToString:@""]) {
                        self.position.text = @"";
                    }
                    else{
                        self.position.text = [dictionary objectForKey:@"Position"];
                    }
                    
                    if ([dictionary objectForKey:@"BirthdayFormatted"] != [NSNull null]){
                        
                        //check if valid date
                        NSDateFormatter * Dateformats= [[NSDateFormatter alloc] init];
                        [Dateformats setDateFormat:@"M/d/yyyy"];
                        NSDate *myDate=[Dateformats dateFromString:[dictionary objectForKey:@"BirthdayFormatted"]];
                        if (myDate != nil){
                            self.age.text = [dictionary objectForKey:@"BirthdayFormatted"];
                        }
                    }
                    
                    if ([dictionary objectForKey:@"Gender"] != [NSNull null]) {
                        self.gender.text = [dictionary objectForKey:@"Gender"];
                    }
                         
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
                        player = true;
                        self.lookingForPartnerView.hidden = TRUE;
                        self.lookingForPlayer.hidden = TRUE;
                        self.lookingForPartnerSwitch.hidden = TRUE;
                        self.lookingForPlayerSwitch.hidden = TRUE;
                        self.marketLabel.hidden = TRUE;
                    }
                    else{
                        player = false;
                        self.playerOnlyView.hidden = true;
                        CGRect aRect = self.aboutView.frame;
                        aRect.origin.y = self.playerOnlyView.frame.origin.y;
                        self.aboutView.frame = aRect;
                        
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
                    NSString *imageURL;
                    @try{
                        imageURL = [dictionary objectForKey:@"PhotoURL"];
                        if ([ValidURL isValidUrl:imageURL]){
                            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];

                            [self.toUpload setBackgroundImage:image forState:UIControlStateNormal];
                            
                            for(UIView *view in self.toUpload.subviews) {
                                view.contentMode = UIViewContentModeScaleAspectFill;
                            }
                        }
                    }
                    @catch (NSException * ex) {
                        
                    }
                    
                    @try{
                        imageURL = [dictionary objectForKey:@"Photo2"];
                        if ([ValidURL isValidUrl:imageURL]){
                            [self.image2Outlet setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL   URLWithString:imageURL]]] forState:UIControlStateNormal];
                            for(UIView *view in self.image2Outlet.subviews) {
                                view.contentMode = UIViewContentModeScaleAspectFill;
                            }
                        }
                    }
                    @catch (NSException * ex) {
                        
                    }
                    
                    @try {
                    imageURL = [dictionary objectForKey:@"Photo3"];
                        if ([ValidURL isValidUrl:imageURL]){
                            [self.image3Outlet setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]] forState:UIControlStateNormal];
                            for(UIView *view in self.image3Outlet.subviews) {
                                view.contentMode = UIViewContentModeScaleAspectFill;
                            }
                        }
                    }
                    @catch (NSException * ex) {
                        
                    }
                    
                    @try{
                    imageURL = [dictionary objectForKey:@"Photo4"];
                        if ([ValidURL isValidUrl:imageURL]){
                            [self.image4Outlet setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]] forState:UIControlStateNormal];
                            for(UIView *view in self.image4Outlet.subviews) {
                                view.contentMode = UIViewContentModeScaleAspectFill;
                            }
                        }
                    }
                    @catch (NSException * ex) {
                        
                    }
                    
                    @try{
                        imageURL = [dictionary objectForKey:@"Photo5"];
                        if ([ValidURL isValidUrl:imageURL]){
                            [self.image5Outlet setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]] forState:UIControlStateNormal];
                            for(UIView *view in self.image5Outlet.subviews) {
                                view.contentMode = UIViewContentModeScaleAspectFill;
                            }
                        }
                    }
                    @catch (NSException * ex) {
                        
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return TRUE;
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

UIDatePicker *itsDatePicker;
- (IBAction) incidentDateValueChanged:(id)sender{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"M/d/yyyy"];
    self.age.text = [dateFormatter stringFromDate:[itsDatePicker date]];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activePlayerTextField = textField;
    
    if ([textField isEqual:self.age]){
        /*itsRightBarButton.title  = @"Done";
        itsRightBarButton.style = UIBarButtonItemStyleDone;
        itsRightBarButton.target = self;
        itsRightBarButton.action = @selector(doneAction:);*/
        itsDatePicker = [[UIDatePicker alloc] init];
        
        if (![self.age.text isEqualToString:@""])
        {
            NSDateFormatter * Dateformats= [[NSDateFormatter alloc] init];
            [Dateformats setDateFormat:@"M/d/yyyy"]; //ex @"MM/DD/yyyy hh:mm:ss"
            NSDate *myDate=[Dateformats dateFromString:self.age.text];
            if (myDate != nil)
                itsDatePicker.date = myDate;
        }
        
        itsDatePicker.datePickerMode = UIDatePickerModeDate;
        [itsDatePicker addTarget:self action:@selector(incidentDateValueChanged:) forControlEvents:UIControlEventValueChanged];
        //datePicker.tag = indexPath.row;
        textField.inputView = itsDatePicker;
    }

    
    float topY = 0;
    /**
     need to do in keyboardWasShown -anything in a view
     **/
    if ([textField isEqual: self.lfpPosition] || [textField isEqual: self.lfpCountry]){
        topY = self.lookingForPlayer.frame.origin.y;
    }
    
    if ([textField isEqual:self.lfpartCountry]){
        topY = self.lookingForPartnerSwitch.frame.origin.y;
    }
    
    if ([textField isEqual:self.email] || [textField isEqual:self.phone]){
        topY = self.privateInformationView.frame.origin.y;
    }
    
    if ([self.activePlayerTextField isEqual:self.position] ||
        [self.activePlayerTextField isEqual:self.height] ||
        [self.activePlayerTextField isEqual:self.weight]){
        topY = self.playerOnlyView.frame.origin.y;
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
    
    if ([self.activePlayerTextField isEqual:self.position] ||
        [self.activePlayerTextField isEqual:self.height] ||
        [self.activePlayerTextField isEqual:self.weight]){
        topY = self.playerOnlyView.frame.origin.y;
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

- (NSString *)contentTypeForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x49:
        case 0x4D:
            return @"image/tiff";
    }
    return nil;
}

- (NSString *)extensionForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            return @"jpg";
        case 0x89:
            return @"png";
        case 0x47:
            return @"gif";
        case 0x49:
        case 0x4D:
            return @"tif";
    }
    return nil;
}

-(void) uploadImage:(UIImage*)image {
    NSData *imageData = UIImageJPEGRepresentation(image, 0.2);     //change Image to NSData
    NSString *baseurl = @"http://newfootballers.com/upload_image.php";
    NSDictionary *parameters;
    
    if (updateImage == 1)
        parameters = @{@"t": @"Profile photo", @"n": @"Profile photo"};
    else
        parameters = @{@"t": [NSString stringWithFormat:@"%d",updateImage],
                       @"n": [NSString stringWithFormat:@"%d",updateImage]};
    
    // 1. Create `AFHTTPRequestSerializer` which will create your request.
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    
    // 2. Create an `NSMutableURLRequest`.
    NSMutableURLRequest *request =
    [serializer multipartFormRequestWithMethod:@"POST" URLString:baseurl
                                    parameters:parameters
                     constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                         [formData appendPartWithFileData:imageData
                                                     name:@"attachment"
                                                 fileName:[NSString stringWithFormat:@"%d-profile.%@", PlayerController.meID, [self extensionForImageData:imageData]]
                                                 mimeType:
                          [self contentTypeForImageData:imageData]];
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
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://newfootballers.com/update_user.php/"]];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [request setHTTPBody:[[NSString stringWithFormat:@"h=%@&w=%@&a=%@&p=%@&u=1&name=%@&surname=%@&phone=%@&email=%@&lookingForPlayer=%@&lfpCountry=%@&lfpPosition=%@&lookingForPartnership=%@&partnerCountry=%@&age=%@&gender=%@",
                           [self.height.text isEqualToString:@""] ? @"0":self.height.text,
                           [self.weight.text isEqualToString:@""] ? @"0":self.weight.text,
                           self.about.text, self.position.text, self.name.text, self.surname.text,self.phone.text,
                           self.email.text, self.lookingForPlayerButton.on ? @"1" : @"0",
                           self.lfpCountry.text, self.lfpPosition.text,
                           self.lookingForPartnerButton.on ? @"1" : @"0",
                           self.lfpartCountry.text, self.age.text, self.gender.text
                           ]dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    NSError *error = nil; NSURLResponse *response = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error) {
        NSLog(@"Error:%@", error.localizedDescription);
    }
    else {
        //success
        //NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data
        //                                                            options:0
        //                                                              error:&error];
        NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:0
                                                                      error:&error];
        for(NSDictionary *dictionary in jsonArray)
        {
            NSLog(@"Data Dictionary is : %@",dictionary);
            NSString *returned = [jsonArray[0] objectForKey:@"value"];
            int accepted = [[jsonArray[0] objectForKey:@"accepted"] intValue];
            
            if (accepted){
                NSInteger age = 0;
                if ([self.age.text length] > 1){
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"M/d/yyyy"];
                    NSDate* birthday = [dateFormatter dateFromString:self.age.text];
                    
                    NSDate* now = [NSDate date];
                    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                                       components:NSYearCalendarUnit
                                                       fromDate:birthday
                                                       toDate:now
                                                       options:0];
                    age = [ageComponents year];
                }
                
                [self.delegate addItemViewController:self didSave :self.name.text :self.surname.text :self.about.text
                                                    :(age > 0 ?  [NSString stringWithFormat:@"%d", age] : @"")
                                                    :self.weight.text :self.height.text :self.position.text
                                                    :(self.lookingForPlayerButton.on ? true : false)
                                                    :self.lfpCountry.text:self.lfpPosition.text
                                                    :(self.lookingForPartnerButton.on ? true : false):self.lfpartCountry.text];
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"PlayerCV"
                                                            message:returned                                                        delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            [alert show];
        }
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
    switch (updateImage) {
        case 1:
            [self.toUpload setBackgroundImage:image forState:UIControlStateNormal];
            for(UIView *view in self.toUpload.subviews) {
                view.contentMode = UIViewContentModeScaleAspectFill;
            }
            break;
        case 2:
            [self.image2Outlet setBackgroundImage:image forState:UIControlStateNormal];
            for(UIView *view in self.image2Outlet.subviews) {
                view.contentMode = UIViewContentModeScaleAspectFill;
            }
            break;
        case 3:
            [self.image3Outlet setBackgroundImage:image forState:UIControlStateNormal];
            for(UIView *view in self.image3Outlet.subviews) {
                view.contentMode = UIViewContentModeScaleAspectFill;
            }
            break;
        case 4:
            [self.image4Outlet setBackgroundImage:image forState:UIControlStateNormal];
            for(UIView *view in self.image4Outlet.subviews) {
                view.contentMode = UIViewContentModeScaleAspectFill;
            }
            break;
        case 5:
            [self.image5Outlet setBackgroundImage:image forState:UIControlStateNormal];
            for(UIView *view in self.image5Outlet.subviews) {
                view.contentMode = UIViewContentModeScaleAspectFill;
            }
            break;
        default:
            break;
    }
    
    
    NSString *itemToPassBack = @"xxxxxxxx";
    NSLog(@"returning: %@",itemToPassBack);
    //[self.delegate addItemViewController:self didFinishEnteringItem:image ];
    [self.delegate addItemViewController:self uploadedImage:image :updateImage - 1];
    
//    - (void)addItemViewController:(id)controller didFinishEnteringItem:(UIImage *)item :(NSString *)name :(NSString *)lname
  //  :(NSString *)about;
    
    [self uploadImage:image];
    
//    [self.delegate playerDetailsViewControllerDidSave:self];
}

- (IBAction)findImage:(id)sender {
    updateImage = 1;
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    
//    [self presentModalViewController:imagePickerController animated:YES];
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void) lookingForPlayerAlign {
    
    if (!player){
        CGRect frame = self.marketLabel.frame;
        frame.origin.y = self.aboutView.frame.origin.y + self.aboutView.frame.size.height + 10;
        self.marketLabel.frame = frame;
        
        frame = self.lookingForPlayerSwitch.frame;
        frame.origin.y = self.marketLabel.frame.origin.y + self.marketLabel.frame.size.height + 10;
        self.lookingForPlayerSwitch.frame = frame;
        
        frame = self.lookingForPlayer.frame;
        frame.origin.y = self.lookingForPlayerSwitch.frame.origin.y + self.lookingForPlayerSwitch.frame.size.height;
        self.lookingForPlayer.frame = frame;
    }
    
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
    
    if (player){
        CGRect frame = self.privateInformationView.frame;
        int y = self.aboutView.frame.origin.y + self.aboutView.frame.size.height + 18;
        frame.origin.y = y;//pass the cordinate which you want
        
        self.privateInformationView.frame= frame;
        self.lookingForPartnerView.hidden = TRUE;
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
    
    bool fbaccount = false;
    if (![PlayerController.facebookID isEqual: [NSNull null]]){
         if (![PlayerController.facebookID isEqualToString:@""] &&
             [PlayerController.facebookID length] > 5){
             
             NSLog(@"%@", PlayerController.facebookID);
             fbaccount = true;
         }
    }
    
    if (!fbaccount){
        CGRect frame = self.changePwd.frame;
        int y = self.privateInformationView.frame.origin.y + self.privateInformationView.frame.size.height + 18;
        frame.origin.y = y;//pass the cordinate which you want
        
        self.changePwd.frame= frame;
        self.scrollview.contentSize = CGSizeMake(320, self.changePwd.frame.origin.y + self.changePwd.frame.size.height + 10);
    }
    else{
        self.changePwd.hidden = true;
        self.scrollview.contentSize = CGSizeMake(320, self.privateInformationView.frame.origin.y + self.privateInformationView.frame.size.height + 10);
    }
}

- (IBAction)lookingForPlayer:(id)sender {
    [self lookingForPlayerAlign];

}
- (IBAction)genderClick:(id)sender {
}



- (IBAction)lookingForPartner:(id)sender {
    [self lookingForPlayerAlign];
}
- (IBAction)changePwdClick:(id)sender {
}
- (IBAction)image2:(id)sender {
    updateImage = 2;
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    
    //[self presentModalViewController:imagePickerController animated:YES];
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (IBAction)image3:(id)sender {
    updateImage = 3;
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    
    //[self presentModalViewController:imagePickerController animated:YES];
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (IBAction)image4:(id)sender {
    updateImage = 4;
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    
    //[self presentModalViewController:imagePickerController animated:YES];
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (IBAction)image5:(id)sender {
    updateImage = 5;
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    
    //[self presentModalViewController:imagePickerController animated:YES];
    [self presentViewController:imagePickerController animated:YES completion:nil];
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
    else if([pickerView isEqual: self.positionPicker]){
        return self.positionArray.count;
    }
    else if([pickerView isEqual: self.positionPicker2]){
        return self.positionArray.count;
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
    else if ([pickerView isEqual: self.positionPicker]){
        if (row < [self.positionArray count]){
            return [self.positionArray objectAtIndex:row];
        }
        else{
            return NULL;
        }
    }
    else if ([pickerView isEqual: self.positionPicker2]){
        if (row < [self.positionArray count]){
            return [self.positionArray objectAtIndex:row];
        }
        else{
            return NULL;
        }
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
    else if ([pickerView isEqual: self.positionPicker]){
        NSString *position = self.positionArray[row];
        self.position.text = position;
    }
    else if ([pickerView isEqual: self.positionPicker2]){
        NSString *position = self.positionArray[row];
        self.lfpPosition.text = position;
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


@end
