//
//  WRQLineLayout.m
//  西邮图书馆
//
//  Created by Apple on 2017/2/20.
//  Copyright © 2017年 WRQ. All rights reserved.
//

#import "WRQLineLayout.h"
#define W [UIScreen mainScreen].bounds.size.width
#define H [UIScreen mainScreen].bounds.size.height

@implementation WRQLineLayout

-(instancetype)init{
    self=[super init];
    if (self) {
        
    }
    return self;
}

- (void)prepareLayout{
    self.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    CGFloat insert=(self.collectionView.frame.size.width-H*0.26)*0.5;
    self.sectionInset=UIEdgeInsetsMake(0, insert, 0, insert);
    self.itemSize=CGSizeMake(W*0.35, H*0.28);
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSArray *array=[super layoutAttributesForElementsInRect:rect];
    CGFloat centerX=self.collectionView.contentOffset.x+self.collectionView.frame.size.width*0.5;
    for (UICollectionViewLayoutAttributes *attributes in array) {
        CGFloat distance=ABS(attributes.center.x-centerX);
        CGFloat scale=1-distance/self.collectionView.frame.size.width;
        attributes.transform=CGAffineTransformMakeScale(scale, scale);
    }
    return array;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    CGRect rect;
    rect.origin.y=0;
    rect.origin.x=proposedContentOffset.x;
    rect.size=self.collectionView.frame.size;
    NSArray *array=[super layoutAttributesForElementsInRect:rect];
    CGFloat centerX=proposedContentOffset.x+self.collectionView.frame.size.width*0.5;
    CGFloat mindistance=MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attributes in array) {
        if (ABS(mindistance)>ABS(attributes.center.x-centerX)) {
            mindistance=attributes.center.x-centerX;
        }
    }
    proposedContentOffset.x+=mindistance;
    return proposedContentOffset;
}
@end
