//
//  ImagiController.m
//  Player CV
//
//  Created by Andrew Buttigieg on 7/11/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import "ImagiController.h"
#import "CMFGalleryCell.h"

@interface ImagiController ()

@end

@implementation ImagiController

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
    
    
    [self loadImages];
    [self setupCollectionView];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark UICollectionView methods

-(void)setupCollectionView {
    [self.collectionView registerClass:[CMFGalleryCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setMinimumInteritemSpacing:0.0f];
    [flowLayout setMinimumLineSpacing:0.0f];
    [self.collectionView setPagingEnabled:YES];
    [self.collectionView setCollectionViewLayout:flowLayout];
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CMFGalleryCell *cell = (CMFGalleryCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    UIImage *imageName = [self.dataArray objectAtIndex:indexPath.row];
    [cell setImageName:imageName.description];
    [cell updateCell];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.collectionView.frame.size;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{

}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark -
#pragma mark Data methods
-(void)loadImages {
    
    //NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Assets"];
    //self.dataArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:sourcePath error:NULL];
    self.dataArray = [[NSMutableArray alloc] init];
    [self.dataArray addObject:@"player.png"];
    [self.dataArray addObject:@"player.png"];
    [self.dataArray addObject:@"player.png"];
}

@end
