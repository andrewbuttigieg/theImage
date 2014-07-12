//
//  CMFGalleryCell.m
//  UICollectionGallery
//
//  Created by Tim on 09/04/2013.
//  Copyright (c) 2013 Charismatic Megafauna Ltd. All rights reserved.
//

#import "CMFGalleryCell.h"

@interface CMFGalleryCell()
@end

@implementation CMFGalleryCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    _imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
    [self.contentView addSubview:_imageView];
    /*
    if (self) {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"CMFGalleryCell" owner:self options:nil];
        
        if ([arrayOfViews count] < 1) {
            return nil;
        }
        
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        
        self = [arrayOfViews objectAtIndex:0];
    }*/
    
    return self;
}

-(void)updateCell {
    
    //NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Assets"];
//    NSString *filename = self.imageName;
    
    //UIImage *image = [UIImage imageNamed:filename];
    /*
    self.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:filename]]];*/
    [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
//    self.imageView.backgroundColor = [UIColor blackColor];
    
}

@end
