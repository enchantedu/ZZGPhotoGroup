//
//  ZZGPhotoGroupCell.h
//  ZZGPhotoGroup
//
//  Created by dito on 16/5/21.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZGImageSource;

typedef void(^ZZGPhotoGroupCellVoidBlock)();

@interface ZZGPhotoGroupCell : UICollectionViewCell

@property (nonatomic, assign) BOOL isLastCollectionCell;
@property (nonatomic, assign) BOOL shouldHideAddButton;

@property (nonatomic, strong) UIImage *cellImage;
@property (nonatomic, strong) ZZGImageSource *sourceImage;

@property (nonatomic, copy) ZZGPhotoGroupCellVoidBlock completionBlock;
@property (nonatomic, copy) ZZGPhotoGroupCellVoidBlock deleteBlock;


+ (NSString *)cellReuseIdentifier;

@end
