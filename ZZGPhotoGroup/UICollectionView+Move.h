//
//  UICollectionView+Move.h
//  ZZGPhotoGroup
//
//  Created by dito on 16/5/22.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UICollectionViewMoveCompleteBlock)(void);

@interface UICollectionView (Move)

@property (nonatomic, strong) NSMutableArray *tempDataSource;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) NSIndexPath *rawIndexPath;
@property (nonatomic, strong) UIView *tempView;
@property (nonatomic, copy) UICollectionViewMoveCompleteBlock actionHandler;

- (void)addLongPressMoveCellWithActionHandler:(void (^)(void))actionHandler;

@end
