//
//  UICollectionViewStackLayout.h
//  Collector
//
//  Created by Florian Heller on 11/12/12.
//  Copyright (c) 2012 Florian Heller. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FHCollectionViewStackLayout : UICollectionViewLayout

@property (assign) int numberOfStacksPerLine;
@property (assign) int horizontalStackSpacing;
@property (assign) int verticalStackSpacing;
@end
