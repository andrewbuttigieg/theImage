//
//  ViewControllerDetail.m
//  theImage
//
//  Created by Andrew Buttigieg on 1/5/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import "ViewControllerDetail.h"

@class PlayerDetailsViewController;



@implementation ViewControllerDetail

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

- (IBAction)goBack:(id)sender
{
	[self.delegate playerDetailsViewControllerDidSave:self];
}

- (IBAction)done:(id)sender
{
    NSString *itemToPassBack = self.textView.text;
    NSLog(@"returning: %@",itemToPassBack);
    [self.delegate addItemViewController:self didFinishEnteringItem:itemToPassBack];
}

static NSString *youTubeVideoHTML = @"<!DOCTYPE html><html><head><style>body{margin:0px 0px 0px 0px;}</style></head> <body> <div id=\"player\"></div> <script> var tag = document.createElement('script'); tag.src = \"http://www.youtube.com/player_api\"; var firstScriptTag = document.getElementsByTagName('script')[0]; firstScriptTag.parentNode.insertBefore(tag, firstScriptTag); var player; function onYouTubePlayerAPIReady() { player = new YT.Player('player', { width:'%0.0f', height:'%0.0f', videoId:'%@', events: { 'onReady': onPlayerReady, } }); } function onPlayerReady(event) { event.target.playVideo(); } </script> </body> </html>";


- (IBAction)playVideo:(id)sender {
    
    NSString *newHTML = @"<html>\
    <style>body{padding:0;margin:0;}</style>\
    <iframe width=\"640\" height=\"390\" src=\"http://www.youtube.com/embed/zL0CCsdS1cE?autoplay=1\" frameborder=\"0\" allowfullscreen></iframe>\
    </html>";
    [self.webView loadHTMLString:newHTML baseURL:nil];
    
    
   /*NSURL *url = [NSURL URLWithString:@"http://www.youtube.com/watch?v=fDXWW5vX-64&autoplay=1"];
    
    [self.webView loadHTMLString:youTubeVideoHTML baseURL:nil];*/
    
    /*//http://www.youtube.com/embed/JW5meKfy3fY?autoplay=1
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];*/
    
   /*
    NSString *html = [NSString stringWithFormat:youTubeVideoHTML, self.frame.size.width, self.frame.size.height, videoId];
    
    [self.webView loadRequest:html baseURL:[[NSBundle mainBundle] resourceURL]];
    */
}
@end
