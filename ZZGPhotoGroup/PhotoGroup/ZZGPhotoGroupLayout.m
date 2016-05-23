//
//  ZZGPhotoGroupLayout.m
//  ZZGPhotoGroup
//
//  Created by dito on 16/5/21.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "ZZGPhotoGroupLayout.h"

@implementation ZZGPhotoGroupLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)prepareLayout {
//    self.itemSize = CGSizeMake(self.height, self.height);
//    self.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
//    self.minimumLineSpacing = 20;
//    self.minimumInteritemSpacing = self.itemSpacing;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    return  array;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}


@end



























































