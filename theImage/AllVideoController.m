//
//  AllVideoController.m
//  theImage
//
//  Created by Andrew Buttigieg on 4/24/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import "AllVideoController.h"
#import "PlayerController.h"
#import <QuartzCore/QuartzCore.h>

@interface AllVideoController ()

@end

@implementation AllVideoController


static float top = 0;
static UIRefreshControl *refreshControl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)isValidUrl:(NSString *)urlString{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    return [NSURLConnection canHandleRequest:request];
}

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    UIView *tappedView = [gesture.view hitTest:[gesture locationInView:gesture.view] withEvent:nil];
    //    NSLog(@"Touch event on view: %@",[tappedView class]);
    //    NSLog([NSString stringWithFormat:@"%d", tappedView.tag]);
    
    
    /////////
    NSString * storyboardName = @"Main_iPhone";
    NSString * viewControllerID = @"PlayerController";
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    PlayerController * controller = (PlayerController *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
    controller.playerID = tappedView.tag;
    [self.navigationController pushViewController:controller animated:YES];
}

- (UIImage*) blur:(UIImage*)theImage
{
    // ***********If you need re-orienting (e.g. trying to blur a photo taken from the device camera front facing camera in portrait mode)
    // theImage = [self reOrientIfNeeded:theImage];
    
    // create our blurred image
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:theImage.CGImage];
    
    // setting up Gaussian Blur (we could use one of many filters offered by Core Image)
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:15.0f] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    // CIGaussianBlur has a tendency to shrink the image a little,
    // this ensures it matches up exactly to the bounds of our original image
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    
    UIImage *returnImage = [UIImage imageWithCGImage:cgImage];//create a UIImage for this function to "return" so that ARC can manage the memory of the blur... ARC can't manage CGImageRefs so we need to release it before this function "returns" and ends.
    CGImageRelease(cgImage);//release CGImageRef because ARC doesn't manage this on its own.
    
    return returnImage;
    
    // *************** if you need scaling
    // return [[self class] scaleIfNeeded:cgImage];
}


+(UIImage*) scaleIfNeeded:(CGImageRef)cgimg {
    bool isRetina = [[[UIDevice currentDevice] systemVersion] intValue] >= 4 && [[UIScreen mainScreen] scale] == 2.0;
    if (isRetina) {
        return [UIImage imageWithCGImage:cgimg scale:2.0 orientation:UIImageOrientationUp];
    } else {
        return [UIImage imageWithCGImage:cgimg];
    }
}

- (UIImage*) reOrientIfNeeded:(UIImage*)theImage{
    
    if (theImage.imageOrientation != UIImageOrientationUp) {
        
        CGAffineTransform reOrient = CGAffineTransformIdentity;
        switch (theImage.imageOrientation) {
            case UIImageOrientationDown:
            case UIImageOrientationDownMirrored:
                reOrient = CGAffineTransformTranslate(reOrient, theImage.size.width, theImage.size.height);
                reOrient = CGAffineTransformRotate(reOrient, M_PI);
                break;
            case UIImageOrientationLeft:
            case UIImageOrientationLeftMirrored:
                reOrient = CGAffineTransformTranslate(reOrient, theImage.size.width, 0);
                reOrient = CGAffineTransformRotate(reOrient, M_PI_2);
                break;
            case UIImageOrientationRight:
            case UIImageOrientationRightMirrored:
                reOrient = CGAffineTransformTranslate(reOrient, 0, theImage.size.height);
                reOrient = CGAffineTransformRotate(reOrient, -M_PI_2);
                break;
            case UIImageOrientationUp:
            case UIImageOrientationUpMirrored:
                break;
        }
        
        switch (theImage.imageOrientation) {
            case UIImageOrientationUpMirrored:
            case UIImageOrientationDownMirrored:
                reOrient = CGAffineTransformTranslate(reOrient, theImage.size.width, 0);
                reOrient = CGAffineTransformScale(reOrient, -1, 1);
                break;
            case UIImageOrientationLeftMirrored:
            case UIImageOrientationRightMirrored:
                reOrient = CGAffineTransformTranslate(reOrient, theImage.size.height, 0);
                reOrient = CGAffineTransformScale(reOrient, -1, 1);
                break;
            case UIImageOrientationUp:
            case UIImageOrientationDown:
            case UIImageOrientationLeft:
            case UIImageOrientationRight:
                break;
        }
        
        CGContextRef myContext = CGBitmapContextCreate(NULL, theImage.size.width, theImage.size.height, CGImageGetBitsPerComponent(theImage.CGImage), 0, CGImageGetColorSpace(theImage.CGImage), CGImageGetBitmapInfo(theImage.CGImage));
        
        CGContextConcatCTM(myContext, reOrient);
        
        switch (theImage.imageOrientation) {
            case UIImageOrientationLeft:
            case UIImageOrientationLeftMirrored:
            case UIImageOrientationRight:
            case UIImageOrientationRightMirrored:
                CGContextDrawImage(myContext, CGRectMake(0,0,theImage.size.height,theImage.size.width), theImage.CGImage);
                break;
                
            default:
                CGContextDrawImage(myContext, CGRectMake(0,0,theImage.size.width,theImage.size.height), theImage.CGImage);
                break;
        }
        
        CGImageRef CGImg = CGBitmapContextCreateImage(myContext);
        theImage = [UIImage imageWithCGImage:CGImg];
        
        CGImageRelease(CGImg);
        CGContextRelease(myContext);
    }
    
    return theImage;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
//    CGFloat y = -scrollView.contentOffset.y;
 //   CGPointMake(self.view.center.x, self.view.center.y);
    int i = 0;
    int j = 0;
    for (i = 1; i < self.scrollview.subviews.count; i++){
        UIScrollView * temp = (UIScrollView *)self.scrollview.subviews[i];
        if (temp.subviews.count == 3){
            UIImageView * iv = (UIImageView *)temp.subviews[0];
            int y = scrollView.contentOffset.y - (j++ * 200) + 64;
            if (y > 0){
                iv.frame = CGRectMake(0, 80 - y, 320, 320);
            }
        }
    }
}

-(void)load{
    //int me = ViewController.playerID;
    
    top = 0.0;
    self.scrollview.delegate = self;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://newfootballers.com/get_all_videos.php/"]];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    //[request setHTTPBody:[[NSString stringWithFormat:@"u=%d", PlayerController.meID]dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            //[self.delegate fetchingGroupsFailedWithError:error];
        } else {
            NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                                        options:0
                                                                          error:&error];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSLog(@"Data Dictionary is : %@",jsonArray);
                
                for(NSDictionary *dictionary in jsonArray)
                {
                    
                    /*[self.nameForTable addObject:[dictionary objectForKey:@"Firstname"]];
                    [self.imageForTable addObject:[dictionary objectForKey:@"PhotoURL"]];
                    
                    
                    [self.textForTable addObject:[dictionary objectForKey:@"Text"]];
                    [self.userTypeForTable addObject:[dictionary objectForKey:@"UserType"]];
                    [self.userIDForTable addObject:[dictionary objectForKey:@"UserID"]];*/
                    

                    NSString *imageURL = [dictionary objectForKey:@"PhotoURL"];
                    imageURL = [imageURL stringByReplacingOccurrencesOfString:@".com/"
                                                                   withString:@".com/[120]-"];
                    UIImage *image;
                    if ([self isValidUrl : imageURL] ){
                        image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
                    }
                    else{
                        //default image
                        image = [UIImage imageNamed:@"player.png"];
                    }
                    UIImageView *iv = [[UIImageView alloc] initWithImage:image];
                    iv.layer.cornerRadius = 30.0;
                    iv.layer.masksToBounds = YES;
                    iv.layer.borderColor = [UIColor lightGrayColor].CGColor;
                    iv.layer.borderWidth = 0.3;
                    iv.frame=CGRectMake(10, 10, 60,60);
                    iv.tag = [[dictionary objectForKey:@"UserID"] intValue];
                    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
                    [iv addGestureRecognizer:singleTap];
                    [iv setMultipleTouchEnabled:YES];
                    [iv setUserInteractionEnabled:YES];

                    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(90, 30, 60, 30)];
                    lb.textColor = [UIColor colorWithRed:(1.0f) green:(1.0f) blue:(1.0f) alpha:1];
                    
                    [lb setFont:[UIFont systemFontOfSize:17]];
                    lb.text = [NSString stringWithFormat:@"%@ %@",
                               [dictionary objectForKey:@"Firstname"],
                               [dictionary objectForKey:@"Lastname"]];
                    [lb sizeToFit];
                    lb.textAlignment = NSTextAlignmentLeft;
                    
                    UIImageView *iv2 = [[UIImageView alloc] initWithImage:[self blur:image]];
                    iv2.frame=CGRectMake(0, 0, 320, 320);
                    
                    UIScrollView *secondScroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0, top, 320, 80)];
                    
                    //  secondScroll.backgroundColor = [UIColor colorWithPatternImage:[self blur:image]];
                    //secondScroll.backgroundColor = [UIColor colorWithPatternImage:image];
                    
                    [secondScroll addSubview:iv2];
                    [secondScroll addSubview:lb];
                    [secondScroll addSubview:iv];
                    top += 80.0;
                    //dispatch_sync(dispatch_get_main_queue(), ^{
                    [self.scrollview addSubview:secondScroll];
                    
                        /* NSString *newHTML = @"<html>\
                         <style>body{padding:0;margin:0;}</style>\
                         <iframe width=\"300\" height=\"200\" src=\"http://www.youtube.com/embed/zL0CCsdS1cE?autoplay=1\" frameborder=\"0\" allowfullscreen></iframe>\
                         </html>";*/
                    
                        //NSString *newHTML = [NSString stringWithFormat:@"<html>\
                        <style>body{padding:0;margin:0;background-color:red}</style>\
                        <iframe width=\"300\" height=\"200\" src=\"%@\" frameborder=\"0\" allowfullscreen></iframe>\
                        </html>", [dictionary objectForKey:@"URL"]];
                        //http://www.youtube.com/embed/zL0CCsdS1cE?autoplay=1
                        
                        //[self.webView loadHTMLString:newHTML baseURL:nil];
                        
                        CGRect webFrame = CGRectMake(00.0, 0.0, 320.0, 200.0);
                        //int tempIndex = (int)([[dictionary objectForKey:@"URL"] rangeOfString:@"/" options:NSBackwardsSearch].location);
                        //NSString *newStr = [[dictionary objectForKey:@"URL"] substringFromIndex:tempIndex];
                        NSString *theURL = [dictionary objectForKey:@"URL"];
                        theURL = [theURL stringByReplacingOccurrencesOfString:@"watch?v=" withString:@"embed/"];
                        
                        //the video
                        NSURL *url = [NSURL URLWithString:theURL];
                        NSURLRequest *req = [NSURLRequest requestWithURL:url];
                        UIWebView *bubbleView = [[UIWebView alloc] initWithFrame:webFrame];
                        bubbleView.scrollView.scrollEnabled = NO;
                        bubbleView.scrollView.bounces = NO;
                        bubbleView.backgroundColor = [UIColor blackColor];
                        bubbleView.frame=CGRectMake(0, top, 320, 200);
                        [bubbleView loadRequest:req];
                        //delete button
                    
                        /*UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                        [button addTarget:self action:@selector(deleteVideo:) forControlEvents:UIControlEventTouchUpInside];
                        button.tag = [[dictionary objectForKey:@"VideoID"] intValue];
                        [button setTitle:@"Delete" forState:UIControlStateNormal];
                        button.frame = CGRectMake(10.0, top + 200, 160.0, 40.0);*/
                        
                        //where to put the view
                        top += 200.0;
                        //dispatch_sync(dispatch_get_main_queue(), ^{
                            [self.scrollview addSubview:bubbleView];
                        //[self.scrollview addSubview:button];
                        
                            //set the scroll of the view
                            self.scrollview.contentSize = CGSizeMake(320, top);
                        //});
                }
//                [self. reloadData];
                [refreshControl endRefreshing];
            });
        }
    }];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    refreshControl = [[UIRefreshControl alloc] init];
    
    self.title = @"Videos";
    
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refreshControl addTarget:self action:@selector(load) forControlEvents:UIControlEventValueChanged];
    [self.scrollview addSubview:refreshControl];
    
    [self load];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
