//
//  AllVideoController.h
//  theImage
//
//  Created by Andrew Buttigieg on 4/24/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllVideoController : UIViewController<UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;
- (NSString *)extractYoutubeID:(NSString *)youtubeURL;

@property (nonatomic, strong) NSMutableArray *link;
@property (nonatomic, strong) NSMutableArray *name;
@property (nonatomic, strong) NSMutableArray *image;
@property (nonatomic, strong) NSMutableArray *country;
@property (nonatomic, strong) NSMutableArray *position;
@property (nonatomic, strong) NSMutableArray *userID;
@end
