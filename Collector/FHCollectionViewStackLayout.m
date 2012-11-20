//
//  UICollectionViewStackLayout.m
//  Collector
//
//  Created by Florian Heller on 11/12/12.
//  Copyright (c) 2012 Florian Heller. All rights reserved.
//

#import "FHCollectionViewStackLayout.h"

@interface FHCollectionViewStackLayout ()
@property (strong) NSMutableArray *layoutAttributes;	//This is a local copy of the layout attributes
	
@end

@implementation FHCollectionViewStackLayout


// We try to fill the entire space
-(CGSize)collectionViewContentSize {
	return self.collectionView.frame.size;
}

- (void)prepareLayout
{
	[super prepareLayout];
	self.horizontalStackSpacing = 200.;
	_numberOfStacksPerLine = floor(self.collectionView.frame.size.width / self.horizontalStackSpacing);

	self.layoutAttributes = [NSMutableArray arrayWithCapacity:[self.collectionView numberOfSections]];

	for (NSInteger section=0; section<[self.collectionView numberOfSections]; section++) {
		NSMutableArray *attributesInSection = [NSMutableArray arrayWithCapacity:[self.collectionView numberOfItemsInSection:section]];

		for (NSInteger row=0; row<[self.collectionView numberOfItemsInSection:section]; row++) {
			NSIndexPath *indexPath = [NSIndexPath indexPathForItem:row inSection:section];
			UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
			//UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];

			if (row==0)
			{
				attributes.zIndex = 1;
				attributes.alpha = 1.0;
			}
			else
			{
				attributes.zIndex = 0;
				attributes.alpha = 0.3;
			}
			float angle = arc4random_uniform(10);
			angle = (angle - 5.)*M_PI/180;
			//attributes.transform3D = CATransform3DMakeScale(angle/10, angle/10, 1.0);
			attributes.transform3D = CATransform3DMakeRotation(angle, 0, 0, 1);
			[attributesInSection addObject:attributes];

		}
		[self.layoutAttributes addObject:attributesInSection];
	}
}



// Make stacks for every section
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{

	UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
	int xCoord = 150+(int)(_horizontalStackSpacing * (attributes.indexPath.section % _numberOfStacksPerLine));
	int yCoord = 150+(int)(_horizontalStackSpacing * floor(attributes.indexPath.section / _numberOfStacksPerLine));
	attributes.center = CGPointMake(xCoord, yCoord);
	attributes.size = CGSizeMake(180, 100);
	return attributes;
	
//	return _layoutAttributes[indexPath.section][indexPath.row];
	


}



- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
	
	//NSArray *attributesInRect = [super layoutAttributesForElementsInRect:rect];
	
	NSMutableArray *attributes = [NSMutableArray array];

	NSPredicate *filterPredicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject,NSDictionary* bindings) {
        
       // UICollectionViewLayoutAttributes* layoutAttributes = evaluatedObject;
        CGRect frame = [(UICollectionViewLayoutAttributes*)evaluatedObject frame];
        return CGRectIntersectsRect(frame,rect);
    }];
	for (NSArray *section in _layoutAttributes)
	{
		[attributes addObjectsFromArray:[section filteredArrayUsingPredicate:filterPredicate]];
	}
	
    return attributes;
}



- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
	return YES;
}
@end
