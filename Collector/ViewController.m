//
//  ViewController.m
//  Collector
//
//  Created by Florian Heller on 11/12/12.
//  Copyright (c) 2012 Florian Heller. All rights reserved.
//

#import "ViewController.h"
#import "Cell.h"
#import "FHCollectionViewStackLayout.h"
NSString *kCellIdentifier = @"imageCell";

@interface ViewController ()
{
	float _initialGestureScale;
}

@property (strong) NSArray *images;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	// We have four images to show
	UIImage *image1 = [UIImage imageNamed:@"logo1-310.png"];
	UIImage *image2 = [UIImage imageNamed:@"logo2-310.png"];
	UIImage *image3 = [UIImage imageNamed:@"logo3-310.png"];
	UIImage *image4 = [UIImage imageNamed:@"logo4-310.png"];
	self.images = @[image1,image2,image3,image4];
	
	// Add the pinch gesture recognizer for pinching gestures
	UIGestureRecognizer *pinchRecognizer =[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
	[self.view addGestureRecognizer:pinchRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView Delegate Methods

#pragma mark - UICollectionView Data Source Methods
// Default is one
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    // we're going to use a custom UICollectionViewCell, which will hold an image and its label
    //
    Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    cell.imageView.image = _images[indexPath.section];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	//static int increase;
	return CGSizeMake(180,100);// CGSizeMake(180-((increase%3)*10), 80+(increase*3));
}

#pragma mark - Gesture recognizers
- (void)handlePinch:(UIPinchGestureRecognizer *)gestureRecognizer;
{
	if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
	{
		_initialGestureScale = gestureRecognizer.scale;

	}
	else
	{
		float difference = gestureRecognizer.scale - _initialGestureScale;
		// If we zoom in we switch to the flow layout, if we zoom out, change to the Stack layout
		if (difference < -0.4 )
		{
			if (!([self.collectionView.collectionViewLayout isKindOfClass:[FHCollectionViewStackLayout class]]))
			{
				[self.collectionView setCollectionViewLayout:[[FHCollectionViewStackLayout alloc] init] animated:YES];
			}
		}
		if (difference > 0.4 )
		{
			if (([self.collectionView.collectionViewLayout isKindOfClass:[FHCollectionViewStackLayout class]]))
			{
				[self.collectionView setCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init] animated:YES];
			}
		}
	}
	
	
}



@end
