//
//  ZZGPhotoGroupLayout.h
//  ZZGPhotoGroup
//
//  Created by dito on 16/5/21.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ZZGPhotoGroupLayoutBlock)(CGFloat height);


@interface ZZGPhotoGroupLayout : UICollectionViewFlowLayout

@property (nonatomic, copy) ZZGPhotoGroupLayoutBlock heightBlock;

@property (nonatomic, assign) CGFloat itemSpacing;
@property (nonatomic, assign) CGFloat height;

@end
